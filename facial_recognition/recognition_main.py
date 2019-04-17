# example to use recognition module

from detect_face import detect_face
from partition import partition
from recognition_train import train
from recognition_test import test

detect_face()
partition()
(train_face_labels, mean_face, num_eigen, eigen_vals, eigen_vecs, weights) = train()
test(train_face_labels, mean_face, num_eigen, eigen_vals, eigen_vecs, weights)

