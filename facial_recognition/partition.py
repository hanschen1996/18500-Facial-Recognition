import os
from shutil import copyfile, rmtree

SRC_DIR = "crop_images"
DEST_TRAIN_DIR = "face_database"
DEST_TEST_DIR = "test_database"

TRAIN_COUNT = 8

def partition(base_path):
    src_dir = "%s/%s"%(base_path, SRC_DIR)
    dest_train_dir = "%s/%s"%(base_path, DEST_TRAIN_DIR)
    dest_test_dir = "%s/%s"%(base_path, DEST_TEST_DIR)

    rmtree(dest_train_dir, ignore_errors=True)
    os.makedirs(dest_train_dir)
    rmtree(dest_test_dir, ignore_errors=True)
    os.makedirs(dest_test_dir)

    all_imgs = os.listdir(src_dir)
    all_imgs.sort()

    prev_index = None
    prev_index_count = 0

    for filename in all_imgs:
        name_list = filename.split(".")
        curr_index = int(name_list[0][len("subject"):])
        if (prev_index is None or prev_index != curr_index):
            copyfile("%s/%s"%(src_dir, filename), "%s/%s"%(dest_train_dir, filename))
            prev_index = curr_index
            prev_index_count = 1
        else:
            if (prev_index_count >= TRAIN_COUNT):
                copyfile("%s/%s"%(src_dir, filename), "%s/%s"%(dest_test_dir, filename))
            else:
                copyfile("%s/%s"%(src_dir, filename), "%s/%s"%(dest_train_dir, filename))
            prev_index_count += 1


