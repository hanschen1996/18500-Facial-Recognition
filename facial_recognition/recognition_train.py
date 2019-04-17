# facial recognition training

import numpy as np
from read_face_data import read_face_data

TRAIN_DIR = "face_database"
CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
CROP_IMG_SIZE = CROP_IMG_WIDTH * CROP_IMG_HEIGHT
EIGEN_THRESHOLD = 0.95

def get_initial_train_data(base_path):
    (train_face_data, train_face_labels) = read_face_data("%s/%s"%(base_path, TRAIN_DIR))
    return (train_face_data, train_face_labels)

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

