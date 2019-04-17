import PIL
from PIL import Image
import os
from subprocess import Popen, PIPE
from nms import nms
import sys

curr_path = os.getcwd()
base_path_index = curr_path.find("app/identityChecker")
sys.path.insert(0, curr_path[:base_path_index] + "facial_recognition")

from recognition_train import train
from recognition_test import test, recognition

INPUT_FILE_EXT = ".png"
#INPUT_IMG_DIR = "identityChecker/static/identityChecker/"
INPUT_IMG_DIR = "/Users/andyshen/Downloads"
DETECT_PROG_PATH = "../facial_detection/vj"
WIDTH = 160
HEIGHT = 120
CROP_IMG_WIDTH = 20
CROP_IMG_HEIGHT = 20
SCORE_THRESHOLD = -500
TRAIN_IMG_DIR = "../facial_recognition/face_database"
OUTPUT_IMG_DIR = "identityChecker/static/identityChecker/"
MIN_FACE_SIZE = 30
COUNTER_FILE = "counter"
TRAIN_SIZE = 8
#STATIC_OUTPUT = "/Users/andyshen/Desktop/18500-Facial-Recognition/app/identityChecker/static/identityChecker/face_output.png"

def detect_face(filename):
    tmp_filename = filename[:-len(INPUT_FILE_EXT)] + ".pgm"

    img = Image.open("%s/%s"%(INPUT_IMG_DIR, filename))
    # resize just in case
    img = img.resize((WIDTH, HEIGHT), Image.NEAREST)
    img = img.convert("L")
    img.save(tmp_filename)

    boxes = []
    p = Popen([DETECT_PROG_PATH, tmp_filename], stdout=PIPE, stdin=PIPE)

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
    os.remove(tmp_filename)
    face_output = "%s_detect.pgm"%(tmp_filename)
    if (os.path.exists(face_output)):
        os.remove(face_output)

    # filter out boxes with low score and small size
    boxes = filter(lambda x:
                       x[-1] >= SCORE_THRESHOLD and
                       x[2]-x[0] >= MIN_FACE_SIZE, boxes)
    boxes = nms(boxes)

    # no face is detected
    if (len(boxes) == 0):
        return (img, None, [])

    # get the first box
    (x1,y1,x2,y2,_) = results[0]
    detect_width = x2-x1
    detect_height = y2-y1

    # crop the face out
    crop_img = img.crop((x1,y1,x2,y2))
    crop_img = crop_img.resize((CROP_IMG_WIDTH, CROP_IMG_HEIGHT))
    return (img, crop_img, boxes)

def find_images(firstname, lastname):
    all_files = os.listdir(INPUT_IMG_DIR)
    filenames = []

    for i in range(TRAIN_SIZE):
        curr_file = "%s_%s_%d.png"%(firstname, lastname, i+1)
        if (curr_file not in all_files):
            print("Cannot find %s"%(curr_file))
            exit(-1)
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

def draw_bounding_box(img, x1, y1, x2, y2):
    # draw the black bounding box
    img_data = img.load()
    for x in range(x1, x2):
        img_data[x,y1] = 0
        img_data[x,y2] = 0

    for y in range(y1, y2):
        img_data[x1,y] = 0
        img_data[x2,y] = 0

def add_face(firstname, lastname):
    # read person label
    counter_file = open(COUNTER_FILE, mode="r")
    counter = int(counter_file.read().strip())
    print("New person takes label %d"%(counter))
    counter_file.close()

    files = find_images(firstname, lastname)
    face_data = np.zeros((0, CROP_IMG_SIZE))
    face_labels = []
    valid_img = None
    success_count = 0

    for filename in files:
        assert(filename.endswith(INPUT_FILE_EXT))
        img_index = int(filename[-len(INPUT_FILE_EXT)-1])

        # detect face in the image
        (img, crop_img, boxes) = detect_face(filename)

        if (len(boxes) == 0):
            print("No face found in %s!"%(filename))
            output_image(img, firstname + "_" + lastname, img_index)
            continue

        # check if more than one face candidate is found
        if (len(boxes) > 1):
            print("%s:\tDetected more than one face, using the first one"%(filename))

        # get the first box
        (x1,y1,x2,y2,_) = results[0]

        # accept this image as training data
        print("%s:\tDetected face window size (width=%d,height=%d)"%(filename, x2-x1, y2-y1))

        # save the cropped image, so we can load these training images
        # if we reboot the webapp
        crop_img.save("%s/subject%d_%s_%s_%d_20x20.pgm"%(TRAIN_IMG_DIR, counter, firstname, lastname, success_count))
        success_count += 1
        face_labels.append(counter)

        # concat the current face to all the faces for the current person
        curr_face_data = np.array(crop_img).reshape((1, CROP_IMG_SIZE))
        face_data = np.concat((face_data, curr_face_data))

        # save this accepted trainng image, so that if any other face fails
        # to detect, this one is reproduced
        if (valid_img is None):
            valid_img = crop_img

        # draw the bounding box for face
        draw_bounding_box(img, x1, y1, x2, y2)

        # output the image with face bounding box
        output_filename = output_image(img, firstname + "_" + lastname, img_index)
        print("Face found! Image saved in %s"%(output_filename))
        print("-------------------------------------------------")

    # check if no face is found at all
    if (valid_img is None):
        print("No face is detected in any of the files for %s_%s"%(firstname, lastname))
        return

    # duplicate valid images if some detection fails
    for i in range(success_count, TRAIN_SIZE):
        valid_img.save("%s/subject%d_%s_%s_%d_20x20.pgm"%(TRAIN_IMG_DIR, counter, firstname, lastname, i))

    counter_file = open("counter", mode="wb")
    counter_file.write(("%d"%(counter+1)).encode())
    counter_file.close()

    return (face_data, np.array(face_labels))

if __name__ == "__main__":
    main()
