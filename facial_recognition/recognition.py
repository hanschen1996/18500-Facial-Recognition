# facial recognition module

import os
from subprocess import Popen, PIPE
import nms
from PIL import Image
import numpy as np
import sys

CROP_IMG_DIR = "crop_images"
CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
CROP_IMG_SIZE = CROP_IMG_WIDTH * CROP_IMG_HEIGHT
PER_LABEL_TRAIN_SIZE = 5
EIGEN_THRESHOLD = 0.95

def get_all_face():
    all_face_data = np.zeros((0, CROP_IMG_SIZE))
    face_labels = []
    filenames = []
    for filename in os.listdir(CROP_IMG_DIR):
        assert(filename.startswith("subject"))
        curr_face_label = int(filename[len("subject"):len("subject") + 2])

        img = Image.open(CROP_IMG_DIR + "/" + filename)
        img_data = np.array(img).reshape((1, CROP_IMG_SIZE))

        all_face_data = np.concatenate((all_face_data, img_data))
        filenames.append(filename)
        face_labels.append(curr_face_label)

    return (all_face_data, np.array(face_labels), np.array(filenames))

def partition(face_data, face_labels, filenames):
    train_indices = []
    test_indices = []
    prev_label = None
    prev_label_count = 0
    for i in range(len(face_labels)):
        curr_label = face_labels[i]
        if (prev_label is None or curr_label != prev_label):
            prev_label = curr_label
            prev_label_count = 1
            train_indices.append(i)
        else:
            if (prev_label_count >= PER_LABEL_TRAIN_SIZE):
                test_indices.append(i)
            else:
                train_indices.append(i)
            prev_label_count += 1
    train_face_data = face_data[train_indices]
    train_face_labels = face_labels[train_indices]
    test_face_data = face_data[test_indices]
    test_face_labels = face_labels[test_indices]
    train_filenames = filenames[train_indices]
    test_filenames = filenames[test_indices]
    return (train_face_data, train_face_labels, test_face_data, test_face_labels, train_filenames, test_filenames)


def train(train_face_data):
    (num_train_face, img_size) = train_face_data.shape
    assert(img_size == CROP_IMG_SIZE)

    # each column is a face
    train_face_data = train_face_data.T
    assert(train_face_data.shape == (CROP_IMG_SIZE, num_train_face))

    # get the average face
    mean_face = train_face_data.mean(1)
    assert(mean_face.shape[0] == CROP_IMG_SIZE)

    # normalize all faces
    norm_face = train_face_data - mean_face[:, None]
    assert(norm_face.shape == (CROP_IMG_SIZE, num_train_face))

    # get covariance matrix    
    cov_face = norm_face.dot(norm_face.T)

    # calculate eigenvalues and eigenvectors
    (eigen_vals, eigen_vecs) = np.linalg.eigh(cov_face)
    sorted_index = eigen_vals.argsort()[::-1]
    eigen_vals = eigen_vals[sorted_index]
    eigen_vecs = eigen_vecs[:, sorted_index]

    # get only the first few eigenvectors with the highest eigenvalues,
    # because later eigenvalues are very small
    eigen_sum = eigen_vals.sum()
    eigen_accum = 0.0
    num_eigen = 0
    for i in range(eigen_vals.shape[0]):
        eigen_accum += eigen_vals[i]
        if (eigen_accum > EIGEN_THRESHOLD * eigen_sum):
            num_eigen = i+1
            break

    eigen_vals = eigen_vals[:num_eigen]
    eigen_vecs = eigen_vecs[:, :num_eigen]
    eigen_vecs_T = eigen_vecs.T # num_eigen x 400
    weights = eigen_vecs_T.dot(norm_face) # num_eigen x 400 multiply 400 x num_face
    return (mean_face, num_eigen, eigen_vals, eigen_vecs_T, weights)

def test(train_face_labels,
         test_face_data,
         test_face_labels,
         test_filenames,
         mean_face,
         num_eigen,
         eigen_vals,
         eigen_vecs,
         weights):
    (num_train_face, ) = train_face_labels.shape
    (num_test_face, ) = test_face_labels.shape

    # dimension checks
    assert(train_face_labels.shape == (num_train_face, ))
    assert(test_face_data.shape == (num_test_face, CROP_IMG_SIZE))
    assert(test_face_labels.shape == (num_test_face, ))
    assert(test_filenames.shape == (num_test_face, ))
    assert(mean_face.shape == (CROP_IMG_SIZE, ))
    assert(eigen_vals.shape == (num_eigen, ))
    assert(eigen_vecs.shape == (num_eigen, CROP_IMG_SIZE))
    assert(weights.shape == (num_eigen, num_train_face))

    test_face_data = test_face_data.T # each column is an image
    eigen_vals = (eigen_vals.astype(float))[:, None]
    assert(eigen_vals.shape == (num_eigen, 1))

    # normalize test images
    diff = test_face_data - mean_face[:, None]
    assert(diff.shape == (CROP_IMG_SIZE, num_test_face))

    # get all weights by dot product eigenvectors with normalized images
    # each column is a weight vector, used to compare with existing face weights
    test_face_weights = eigen_vecs.dot(diff)
    assert(test_face_weights.shape == (num_eigen, num_test_face))

    # count the number of correctly recognized images
    correct = 0

    for i in range(num_test_face):
        diff_weights = test_face_weights[:, i][:, None] - weights
        assert(diff_weights.shape == weights.shape)

        weighted_distances = np.square(diff_weights)# / eigen_vals
        assert(weighted_distances.shape == weights.shape)

        # sum of square of each image in the training set
        sum_distances = weighted_distances.sum(0)
        assert(sum_distances.shape == (num_train_face, ))

        predicted_label = train_face_labels[sum_distances.argmin()]
        correct_label = test_face_labels[i]
        if (predicted_label == correct_label):
            #print("%s: CORRECT!"%(test_filenames[i]))
            correct += 1
        else:
            #print("%s: incorrect!"%(test_filenames[i]))
            pass

    print("Total number of test images: %d, correct: %d, correctness percentage: %f"
          %(num_test_face, correct, float(correct) / num_test_face))

def recognition(train_face_labels,
                img_path,
                mean_face,
                num_eigen,
                eigen_vals,
                eigen_vecs,
                weights):
    img = Image.open(img_path)
    img = img.resize((CROP_IMG_HEIGHT, CROP_IMG_WIDTH))

    img_arr = np.array(img).reshape(CROP_IMG_SIZE)
    diff = img_arr - mean_face # (400, )
    diff = diff[:, None] # 400 x 1

    new_face_weight = eigen_vecs.dot(diff) # num_eigen x 1
    diff_weights = new_face_weight - weights # num_eigen x num_train_face
    assert(diff_weights.shape == weights.shape)

    distances = np.square(diff_weights).sum(0) # (num_train_face, )
    assert(distances.shape[0] == weights.shape[1])
    #print(distances)
    #print("face index: %d"%(distances.argmin()))
    print("face label: %d"%(train_face_labels[distances.argmin()]))
    #return face_labels[distances.argmin()]

# reading training and test images
print("Reading training and test images from %s..."%(CROP_IMG_DIR))
(face_data, face_labels, filenames) = get_all_face()
print("Reading images finished!")

# partition images into training set and test set
print("Partition images into a training set and test set... Training set includes %d images per subject"%(PER_LABEL_TRAIN_SIZE))
(train_face_data, train_face_labels, test_face_data, test_face_labels, train_filenames, test_filenames) = partition(face_data, face_labels, filenames)
print("Partition finished!")

print("Number of training images: %d"%(train_face_labels.shape[0]))
print("Number of test images: %d"%(test_face_labels.shape[0]))
print("Training now...")

(mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train(train_face_data)

print("Training finished! Number of eigenfaces: %d"%(eigen_vecs.shape[0]))

print("Testing now...")
test(train_face_labels,
     test_face_data,
     test_face_labels,
     test_filenames,
     mean_face,
     num_eigen,
     eigen_vals,
     eigen_vecs,
     weights)
print("Testing finished!")

if (len(sys.argv) > 1):
    print("Recognizing face in image %s"%(sys.argv[1]))
    recognition(train_face_labels, sys.argv[1], mean_face, num_eigen, eigen_vals, eigen_vecs, weights)
