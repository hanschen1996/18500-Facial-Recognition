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
        if (filename.startswith("subject")):
            name_list = filename.split(".")
            curr_face_label = int(name_list[0][len("subject"):]) - 1

            img = Image.open(dir_name + "/" + filename)
            img_data = np.array(img).reshape((1, CROP_IMG_SIZE))

            data = np.concatenate((data, img_data))
            labels.append(curr_face_label)

    return (data, np.array(labels))
