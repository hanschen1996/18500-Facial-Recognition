# main function to start the recognition system

import os
from partition import partition
from recognition_train import train, get_initial_train_data, TRAIN_DIR
from recognition_test import test

def reset_labels(base_path):
    label_file = open("%s/labels"%(base_path), mode="wb")
    label_file.write("01\n02\n03\n04\n05\n06\n07\n08\n09\n10\n11\n12\n13\n14\n15\n".encode())
    label_file.close()

def recognition_init(base_path):
    train_dir = "%s/%s"%(base_path, TRAIN_DIR)

    # assume crop_images/ exists
    # initial faces are not partitioned
    if (not os.path.exists(train_dir) or (len(os.listdir(train_dir)) == 0)):
        print("Partition initial database into training and test set")
        partition(base_path)
        reset_labels(base_path)

    (train_face_data, train_face_labels) = get_initial_train_data(base_path)
    (mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train(train_face_data)

    # verify model health
    test(base_path, train_face_labels, mean_face, num_eigen, eigen_vals, eigen_vecs, weights)

    # read the existing label file
    label_file = open("%s/labels"%(base_path), mode="r")
    names = []
    for line in label_file.readlines():
        names.append(line.strip())

    return (train_face_data, train_face_labels, names, mean_face, num_eigen, eigen_vals, eigen_vecs, weights)

if __name__ == "__main__":
    recognition_init(".")
