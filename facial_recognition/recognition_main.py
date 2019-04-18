# main function to start the recognition system

import os
from detect_face import detect_face
from partition import partition
from recognition_train import train, get_initial_train_data, TRAIN_DIR
from recognition_test import test

def recognition_init(base_path):
    if (not os.path.exists("%s/crop_images"%(base_path))):
        detect_face()

    if (not os.path.exists("%s/%s"%(base_path, TRAIN_DIR))):
        partition()

    (train_face_data, train_face_labels) = get_initial_train_data(base_path)
    (mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train(train_face_data)

    # verify model health
    test(base_path, train_face_labels, mean_face, num_eigen, eigen_vals, eigen_vecs, weights)

    label_file = open("%s/labels"%(base_path), mode="r")
    names = []
    for line in label_file.readlines():
        names.append(line.strip())

    return (train_face_data, train_face_labels, names, mean_face, num_eigen, eigen_vals, eigen_vecs, weights)

if __name__ == "__main__":
    recognition_init(".")
