import PIL
from PIL import Image
import os
from subprocess import Popen, PIPE
from nms import nms
import sys
import numpy as np
import time

INPUT_FILE_EXT = ".png"
INPUT_IMG_DIR = "/Users/andyshen/Downloads" #"/mnt/c/Users/asus/Downloads"
DETECT_PROG_PATH = "../facial_detection/vj"
WIDTH = 160
HEIGHT = 120
CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
CROP_IMG_SIZE = CROP_IMG_HEIGHT * CROP_IMG_WIDTH
SCORE_THRESHOLD = -500
TRAIN_IMG_DIR = "../facial_recognition/face_database"
OUTPUT_IMG_DIR = "identityChecker/static/identityChecker/"
MIN_FACE_SIZE = 35
TRAIN_SIZE = 8
DETECT_IMG_NAME = "detect_img.pgm"

def draw_bounding_box(img, x1, y1, x2, y2):
    # draw the black bounding box
    img_data = img.load()
    for x in range(x1, x2):
        img_data[x,y1] = 0
        img_data[x,y2] = 0

    for y in range(y1, y2):
        img_data[x1,y] = 0
        img_data[x2,y] = 0

def detect_face_software(img):
    img.save(DETECT_IMG_NAME)

    boxes = []

    start_time = time.time()
    p = Popen([DETECT_PROG_PATH, DETECT_IMG_NAME], stdout=PIPE, stdin=PIPE)
    exit_status = p.wait()
    end_time = time.time()
    print("Software facial detection takes %f seconds"%(end_time - start_time))

    if (exit_status < 0):
        os.remove(DETECT_IMG_NAME)
        return []

    while (True):
        line = p.stdout.readline()
        line = line.decode().strip()
        if (line == ""): break

        if (line.startswith('Face:(')):
            box = line[len("Face:("):-1].split(",")
            boxes.append(list(map(lambda x: int(x), box)))
        elif (line.startswith("ERROR:")):
            break

    # remove temporary files
    os.remove(DETECT_IMG_NAME)
    face_output = "%s_detect.pgm"%(DETECT_IMG_NAME)
    if (os.path.exists(face_output)):
        os.remove(face_output)

    # filter out boxes with low score and small size
    boxes = list(filter(lambda x:
                       x[-1] >= SCORE_THRESHOLD and
                       x[2]-x[0] >= MIN_FACE_SIZE, boxes))
    boxes = nms(boxes)
    return boxes

def detect_face_fpga(port, img_data):
    assert(img_data.shape == (IMG_HEIGHT, IMG_WIDTH))
    data = bytes()

    for i in range(IMG_HEIGHT):
        for j in range(IMG_WIDTH):
            # PYTHON3 ONLY!
            data += bytes([img_data[i][j]])

    start_time = time.time()
    assert(port.write(data) == 19200)
    is_face = ord(port.read())
    end_time = time.time()
    print("FPGA facial detection takes %f"%(end_time - start_time))

    if (not is_face):
        return []

    x1 = ord(port.read())
    y1 = ord(port.read())
    x2 = ord(port.read())
    y2 = ord(port.read())

    # need to put a dummy 0 for score to match with software output
    return [(x1, y1, x2, y2, 0)]


def detect_face(filename, method="software", fpga_port=None):
    # read the image
    img = Image.open("%s/%s"%(INPUT_IMG_DIR, filename))

    # resize just in case
    img = img.resize((WIDTH, HEIGHT), Image.NEAREST)

    # grayscale the image
    gray_img = img.convert("L")

    # remove the original image since we already read it in
    os.remove("%s/%s"%(INPUT_IMG_DIR, filename))
    boxes = []

    if (method == "software"):
        boxes = detect_face_software(gray_img)
    elif (method == "fpga"):
        boxes = detect_face_fpga(fpga_port, np.array(gray_img))
    elif (method == "both"):
        boxes = detect_face_software(gray_img)
        boxes_fpga = detect_face_fpga(fpga_port, np.array(gray_img))

        software_num_box = len(boxes)
        fpga_num_box = len(boxes_fpga)

        if (software_num_box == 0 and fpga_num_box != 0):
            print("Software didn't detect any face, but fpga says yes?")
        elif (software_num_box > 0 and fpga_num_box == 1):
            print("Software detected face, but fpga didn't detect any?")
        else:
            if (boxes[0] != boxes_fpga[0]):
                print("Software and fpga detected different faces?")

    # no face is detected
    if (len(boxes) == 0):
        return (img, None, [])

    # get the first box
    (x1,y1,x2,y2,_) = boxes[0]
    detect_width = x2-x1
    detect_height = y2-y1

    # draw a rectangle in the original image
    draw_bounding_box(img, x1, y1, x2, y2)

    # crop the face out
    crop_img = gray_img.crop((x1,y1,x2,y2))
    crop_img = crop_img.resize((CROP_IMG_WIDTH, CROP_IMG_HEIGHT))
    return (img, crop_img, boxes)

def find_images(name):
    all_files = os.listdir(INPUT_IMG_DIR)
    filenames = []

    for i in range(TRAIN_SIZE):
        curr_file = "%s_%d.png"%(name, i+1)
        if (curr_file not in all_files):
            print("Cannot find %s"%(curr_file))
            return []
        filenames.append(curr_file)
    return filenames

def output_image(img, filename, img_index=None):
    output_filename = None

    if (img_index is None):
        output_filename = "%s/%s.png"%(OUTPUT_IMG_DIR, filename)
    else:
        output_filename = "%s/%s_%d.png"%(OUTPUT_IMG_DIR, filename, img_index)
    img.save(output_filename)
    return output_filename

def add_face(name, label, fpga_port=None):
    files = find_images(name)
    if (len(files) != TRAIN_SIZE):
        return (None, None)

    face_data = np.zeros((0, CROP_IMG_SIZE))
    face_labels = []
    valid_img = None
    success_count = 0

    for filename in files:
        assert(filename.endswith(INPUT_FILE_EXT))
        img_index = int(filename[-len(INPUT_FILE_EXT)-1])

        # detect face in the image
        (img, crop_img, boxes) = detect_face(filename, fpga_port=fpga_port)

        if (len(boxes) == 0):
            print("No face found in %s!"%(filename))
            output_image(img, name, img_index)
            continue

        # check if more than one face candidate is found
        if (len(boxes) > 1):
            print("%s:\tDetected more than one face, using the first one"%(filename))

        # get the first box
        (x1,y1,x2,y2,_) = boxes[0]

        # accept this image as training data
        print("%s:\tDetected face window size (width=%d,height=%d)"%(filename, x2-x1, y2-y1))

        # save the cropped image, so we can load these training images
        # if we reboot the webapp
        crop_img.save("%s/subject%d.%s_%d_20x20.pgm"%(TRAIN_IMG_DIR, label+1, name, success_count))
        success_count += 1

        # record this face in our training set
        face_labels.append(label)
        curr_face_data = np.array(crop_img).reshape((1, CROP_IMG_SIZE))
        face_data = np.concatenate((face_data, curr_face_data))

        # save this accepted trainng image, so that if any other face fails
        # to detect, this one is reproduced
        if (valid_img is None):
            valid_img = crop_img

        # output the file to display for webapp
        output_filename = output_image(img, name, img_index)
        print("Face found! Image saved in %s"%(output_filename))
        print("-------------------------------------------------")

    # check if no face is found at all
    if (valid_img is None):
        print("No face is detected in any of the files for %s"%(name))
        return (None, None)

    # duplicate valid images if some detection fails
    for i in range(success_count, TRAIN_SIZE):
        valid_img_arr = np.array(valid_img).reshape((1, CROP_IMG_SIZE))
        face_data = np.concatenate((face_data, valid_img_arr))
        face_labels.append(label)
        valid_img.save("%s/subject%d.%s_%d_20x20.pgm"%(TRAIN_IMG_DIR, label+1, name, i))

    face_labels = np.array(face_labels)
    assert(face_data.shape == (TRAIN_SIZE, CROP_IMG_SIZE))
    assert(face_labels.shape == (TRAIN_SIZE, ))
    return (face_data, face_labels)

if __name__ == "__main__":
    main()
