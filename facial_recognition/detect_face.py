# detection module that runs C program to locate the face,
# crop the face, and downscale the face into a 20x20 image

import os
from subprocess import Popen, PIPE
import nms
from PIL import Image
import numpy as np
import sys

IMG_WIDTH = 160
IMG_HEIGHT = 120
SCORE_THRESHOLD = -500
DETECTION_PROG_PATH = "../facial_detection/vj"
IMG_DIR =  "images"
CROP_IMG_DIR = "crop_images"
CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
CROP_IMG_SIZE = CROP_IMG_WIDTH * CROP_IMG_HEIGHT


def detect_face():
    for filename in os.listdir(IMG_DIR):
        p = Popen([DETECTION_PROG_PATH, IMG_DIR + "/" + filename], stdout=PIPE, stdin=PIPE)
        boxes = []

        while (True):
            line = p.stdout.readline()
            line = line.decode().strip()
            if (line == ""): break

            if (line.startswith('Face:(')):
                box = line[len("Face:("):-1].split(",")
                boxes.append(list(map(lambda x: int(x), box)))
            elif (line.startswith("ERROR:")):
                print("%s:\tNot using this image for training, no face found"%(filename))
                print("------------------------------------------------")
                break

        boxes = filter(lambda x: x[-1] >= SCORE_THRESHOLD, boxes)
        # use nms to find all faces
        results = nms.nms(boxes)
        if (results == []): continue

        # remove temporary output file if any face is found
        os.remove("%s/%s_detect.pgm"%(IMG_DIR, filename))
        if (len(results) > 1):
            print("%s:\tDetected more than one face, using the first one"%(filename))

        # save image after cropping
        (x1,y1,x2,y2,_) = results[0]
        detect_width = x2-x1
        detect_height = y2-y1

        # some preliminary checks to ensure training data quality
        if (x1 > IMG_WIDTH / 2 or x2 < IMG_WIDTH / 2 or y1 > IMG_HEIGHT / 2 or y2 < IMG_HEIGHT / 2):
            print("%s:\tNot using this image for training, face not in the middle?"%(filename))
            print("------------------------------------------------")
            continue

        if (detect_width < 40 or detect_height < 40):
            print("%s:\tNot using this image for training, face size too small?"%(filename))
            print("------------------------------------------------")
            continue

        # accept this image as training data
        print("%s:\tDetected face window size (width=%d,height=%d)"%(filename, detect_width, detect_height))

        # crop the face out
        img = Image.open(IMG_DIR + "/" + filename)
        img = img.crop((x1,y1,x2,y2))
        img = img.resize((CROP_IMG_WIDTH, CROP_IMG_HEIGHT))
        img.save("%s/%s_20x20.pgm"%(CROP_IMG_DIR, filename))

        print("------------------------------------------------")

detect_face()
