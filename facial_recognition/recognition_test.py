# facial recognition testing

from PIL import Image
import numpy as np
import sys
from read_face_data import read_face_data

TEST_DIR = "test_database"
CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
CROP_IMG_SIZE = CROP_IMG_WIDTH * CROP_IMG_HEIGHT

def test(base_path,
         train_face_labels,
         mean_face,
         num_eigen,
         eigen_vals,
         eigen_vecs,
         weights):
    (test_face_data, test_face_labels) = read_face_data("%s/%s"%(base_path, TEST_DIR))
    (num_train_face, ) = train_face_labels.shape
    (num_test_face, ) = test_face_labels.shape

    # dimension checks
    assert(train_face_labels.shape == (num_train_face, ))
    assert(test_face_data.shape == (num_test_face, CROP_IMG_SIZE))
    assert(test_face_labels.shape == (num_test_face, ))
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

def recognition(img_arr,
                train_face_labels,
                mean_face,
                num_eigen,
                eigen_vals,
                eigen_vecs,
                weights):
    (num_train_face, ) = train_face_labels.shape

    # dimension checks
    assert(mean_face.shape == (CROP_IMG_SIZE, ))
    assert(eigen_vals.shape == (num_eigen, ))
    assert(eigen_vecs.shape == (num_eigen, CROP_IMG_SIZE))
    assert(weights.shape == (num_eigen, num_train_face))

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
    return train_face_labels[distances.argmin()]
