# xml parser
import requests
import os
import xml.etree.ElementTree as ET

def get_xml():
    url = "https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml"
    resp = requests.get(url)
    with open("vj_weights.xml", "wb") as f:
        f.write(resp.content)

if (not os.path.isfile("./vj_weights.xml")):
    get_xml()

pyramid_widths = [160, 128, 102, 81, 64, 51, 40]
pyramid_heights = [120, 96, 76, 60, 48, 38, 30]

num_stage = 0
num_feature = 0
window_size = 0
stage_num_feature = []

rectangle1_x1 = []
rectangle1_y1 = []
rectangle1_x2 = []
rectangle1_y2 = []
rectangle1_weights = []

rectangle2_x1 = []
rectangle2_y1 = []
rectangle2_x2 = []
rectangle2_y2 = []
rectangle2_weights = []

rectangle3_x1 = []
rectangle3_y1 = []
rectangle3_x2 = []
rectangle3_y2 = []
rectangle3_weights = []

feature_threshold = []
feature_above = []
feature_below = []

stage_threshold = []

STAGE_SCALE = 128
FEATURE_SCALE = 128

tree = ET.parse("vj_weights.xml")
root = tree.getroot()

# count the total number of stages
for item in root.findall("./cascade/stageNum"):
    num_stage = int(item.text)

print("Number of stages: " + str(num_stage))

# count the total number of features
stage_num_feature.append(0)
for item in root.findall("./cascade/stages/_/maxWeakCount"):
    num_feature += int(item.text)
    stage_num_feature.append(num_feature)

for item in root.findall("./cascade/height"):
    window_size = int(item.text)

print("Number of features: " + str(num_feature))

# get stage threshold
is_stage_end = [0] * 2913
stage_threshold = [0] * 2913
stage_index = 1
for item in root.findall("./cascade/stages/_/stageThreshold"):
    is_stage_end[stage_num_feature[stage_index] - 1] = 1
    stage_threshold[stage_num_feature[stage_index] - 1] = (int(round(STAGE_SCALE * (float(item.text)))))
    stage_index += 1
assert(stage_index == 26)

# get feature threshold
count = 0
for item in root.findall("./cascade/stages/_/weakClassifiers/_/internalNodes"):
    texts = item.text.strip().split(" ")
    assert(int(texts[0]) == 0)
    assert(int(texts[1]) == -1)
    assert(int(texts[2]) == count)
    count += 1
    feature_threshold.append(int(round(FEATURE_SCALE * float(texts[-1]))))

# get values to use based on threshold
for item in root.findall("./cascade/stages/_/weakClassifiers/_/leafValues"):
    texts = item.text.strip().split(" ")
    feature_below.append(int(round(STAGE_SCALE * float(texts[0]))))
    feature_above.append(int(round(STAGE_SCALE * float(texts[1]))))


for item in root.iter("rects"):
    rect_index = 0
    for rect in item.iter("_"):
        texts = rect.text.strip().split(" ")
        assert(len(texts) == 5)

        texts[0] = int(texts[0]) # x
        texts[1] = int(texts[1]) # y
        texts[2] = int(texts[2]) # width
        texts[3] = int(texts[3]) # height
        texts[4] = int(round(FEATURE_SCALE * float(texts[4])))

        if (rect_index == 0):
            rectangle1_x1.append(texts[0])
            rectangle1_y1.append(texts[1])
            rectangle1_x2.append(texts[0] + texts[2])
            rectangle1_y2.append(texts[1] + texts[3])
            rectangle1_weights.append(texts[4])
        elif (rect_index == 1):
            rectangle2_x1.append(texts[0])
            rectangle2_y1.append(texts[1])
            rectangle2_x2.append(texts[0] + texts[2])
            rectangle2_y2.append(texts[1] + texts[3])
            rectangle2_weights.append(texts[4])
        else:
            rectangle3_x1.append(texts[0])
            rectangle3_y1.append(texts[1])
            rectangle3_x2.append(texts[0] + texts[2])
            rectangle3_y2.append(texts[1] + texts[3])
            rectangle3_weights.append(texts[4])

        rect_index += 1

    assert(rect_index == 2 or rect_index == 3)
    if (rect_index == 2):
        rectangle3_x1.append(0)
        rectangle3_y1.append(0)
        rectangle3_x2.append(0)
        rectangle3_y2.append(0)
        rectangle3_weights.append(0)


assert(len(stage_threshold) == num_feature)
assert(len(feature_threshold) == num_feature)
assert(len(feature_below) == num_feature)
assert(len(feature_above) == num_feature)
assert(len(rectangle1_x1) == num_feature)
assert(len(rectangle1_y1) == num_feature)
assert(len(rectangle1_x2) == num_feature)
assert(len(rectangle1_y2) == num_feature)
assert(len(rectangle1_weights) == num_feature)
assert(len(rectangle2_x1) == num_feature)
assert(len(rectangle2_y1) == num_feature)
assert(len(rectangle2_x2) == num_feature)
assert(len(rectangle2_y2) == num_feature)
assert(len(rectangle2_weights) == num_feature)
assert(len(rectangle3_x1) == num_feature)
assert(len(rectangle3_y1) == num_feature)
assert(len(rectangle3_x2) == num_feature)
assert(len(rectangle3_y2) == num_feature)
assert(len(rectangle3_weights) == num_feature)

weights_file = open("vj_weights.vh", mode="wb")

# .h header comments
weights_file.write("/** @file vj_weights.vh\n")
weights_file.write(" *  @brief Viola-Jones weights data structure\n")
weights_file.write(" */\n\n")

weights_file.write("// assume we use haarcascade_frontalface_default.xml\n")
weights_file.write("`define NUM_STAGE %d\n"%(num_stage))
weights_file.write("`define NUM_FEATURE %d\n"%(num_feature))
weights_file.write("`define WINDOW_SIZE %d\n"%(window_size))
weights_file.write("`define LAPTOP_WIDTH %d\n"%(pyramid_widths[0]))
weights_file.write("`define LAPTOP_HEIGHT %d\n"%(pyramid_heights[0]))
weights_file.write("`define PYRAMID_LEVELS %d\n\n"%(len(pyramid_widths)))

def write_array(arr, width):
    arr_len = len(arr)
    weights_file.write("{")
    for s in range(arr_len - 1, -1, -1):
        val = arr[s]
        if (val < 0): val += 2**32

        weights_file.write("%d'd%d"%(width, val))
        if (s != 0):
            weights_file.write(",")
    weights_file.write("}")

def write_array_body(arr, arr_name, width):
    arr_len = len(arr)
    weights_file.write("`define %s "%(arr_name))
    if (type(arr[0]) == list):
        weights_file.write("{")
        for i in range(arr_len - 1, -1, -1):
            write_array(arr[i], width)
            if (i != 0):
                weights_file.write(",")
        weights_file.write("}")
    else:
        write_array(arr, width)
    weights_file.write("\n")

## write data
write_array_body(pyramid_widths, "pyramid_widths".upper(), 32)
write_array_body(pyramid_heights, "pyramid_heights".upper(), 32)
weights_file.write("\n")

# number of features in each stage
write_array_body(stage_num_feature, "stage_num_feature".upper(), 32)
weights_file.write("// thresholds are negative values\n")
write_array_body(stage_threshold, "stage_threshold".upper(), 32)
write_array_body(is_stage_end, "is_stage_end".upper(), 1)
weights_file.write("\n")

write_array_body(rectangle1_x1, "rectangle1_x1".upper(), 5)
write_array_body(rectangle1_y1, "rectangle1_y1".upper(), 5)
write_array_body(rectangle1_x2, "rectangle1_x2".upper(), 5)
write_array_body(rectangle1_y2, "rectangle1_y2".upper(), 5)
write_array_body(rectangle1_weights, "rectangle1_weights".upper(), 32)

write_array_body(rectangle2_x1, "rectangle2_x1".upper(), 5)
write_array_body(rectangle2_y1, "rectangle2_y1".upper(), 5)
write_array_body(rectangle2_x2, "rectangle2_x2".upper(), 5)
write_array_body(rectangle2_y2, "rectangle2_y2".upper(), 5)
write_array_body(rectangle2_weights, "rectangle2_weights".upper(), 32)

write_array_body(rectangle3_x1, "rectangle3_x1".upper(), 5)
write_array_body(rectangle3_y1, "rectangle3_y1".upper(), 5)
write_array_body(rectangle3_x2, "rectangle3_x2".upper(), 5)
write_array_body(rectangle3_y2, "rectangle3_y2".upper(), 5)
write_array_body(rectangle3_weights, "rectangle3_weights".upper(), 32)

write_array_body(feature_threshold, "feature_threshold".upper(), 32)
write_array_body(feature_above, "feature_above".upper(), 32)
write_array_body(feature_below, "feature_below".upper(), 32)
