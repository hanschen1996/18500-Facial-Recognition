import numpy as np
import os
from PIL import Image

CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
CROP_IMG_SIZE = CROP_IMG_WIDTH * CROP_IMG_HEIGHT

def read_face_data(dir_name):
    data = np.zeros((0, CROP_IMG_SIZE))
    labels = []
    filenames = os.listdir(dir_name)
    filenames.sort()

    for filename in filenames:
        assert(filename.startswith("subject"))
        curr_face_label = int(filename[len("subject"):len("subject") + 2])

        img = Image.open(dir_name + "/" + filename)
        img_data = np.array(img).reshape((1, CROP_IMG_SIZE))

        data = np.concatenate((data, img_data))
        labels.append(curr_face_label)

    return (data, np.array(labels))
