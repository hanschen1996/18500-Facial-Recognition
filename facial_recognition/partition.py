import os
from shutil import copyfile, rmtree

SRC_DIR = "crop_images"
DEST_TRAIN_DIR = "face_database"
DEST_TEST_DIR = "test_database"

TRAIN_COUNT = 8

def partition():
    rmtree(DEST_TRAIN_DIR, ignore_errors=True)
    os.makedirs(DEST_TRAIN_DIR)
    rmtree(DEST_TEST_DIR, ignore_errors=True)
    os.makedirs(DEST_TEST_DIR)

    all_imgs = os.listdir(SRC_DIR)
    all_imgs.sort()

    prev_index = None
    prev_index_count = 0

    for filename in all_imgs:
        curr_index = int(filename[len("subject"):len("subject")+2])
        if (prev_index is None or prev_index != curr_index):
            copyfile("%s/%s"%(SRC_DIR, filename), "%s/%s"%(DEST_TRAIN_DIR, filename))
            prev_index = curr_index
            prev_index_count = 1
        else:
            if (prev_index_count >= TRAIN_COUNT):
                copyfile("%s/%s"%(SRC_DIR, filename), "%s/%s"%(DEST_TEST_DIR, filename))
            else:
                copyfile("%s/%s"%(SRC_DIR, filename), "%s/%s"%(DEST_TRAIN_DIR, filename))
            prev_index_count += 1


