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

pyramid_widths = [160, 133, 111, 92, 77, 64, 53, 44, 37, 31]
pyramid_heights = [120, 99, 83, 69, 57, 48, 40, 33, 27, 23]

x_ratios = [78841, 94467, 113976, 136179, 163841, 197845, 238313, 283399, 338251]
y_ratios = [79438, 94751, 113976, 137971, 163841, 196609, 238313, 291272, 341927]

pyramid1_x_ratios = []
pyramid1_y_ratios = []
for i in range(pyramid_widths[1]):
    pyramid1_x_ratios.append((i * x_ratios[0]) >> 16)
for i in range(pyramid_heights[1]):
    pyramid1_y_ratios.append((i * y_ratios[0]) >> 16)

pyramid2_x_ratios = []
pyramid2_y_ratios = []
for i in range(pyramid_widths[2]):
    pyramid2_x_ratios.append((i * x_ratios[1]) >> 16)
for i in range(pyramid_heights[2]):
    pyramid2_y_ratios.append((i * y_ratios[1]) >> 16)

pyramid3_x_ratios = []
pyramid3_y_ratios = []
for i in range(pyramid_widths[3]):
    pyramid3_x_ratios.append((i * x_ratios[2]) >> 16)
for i in range(pyramid_heights[3]):
    pyramid3_y_ratios.append((i * y_ratios[2]) >> 16)

pyramid4_x_ratios = []
pyramid4_y_ratios = []
for i in range(pyramid_widths[4]):
    pyramid4_x_ratios.append((i * x_ratios[3]) >> 16)
for i in range(pyramid_heights[4]):
    pyramid4_y_ratios.append((i * y_ratios[3]) >> 16)

pyramid5_x_ratios = []
pyramid5_y_ratios = []
for i in range(pyramid_widths[5]):
    pyramid5_x_ratios.append((i * x_ratios[4]) >> 16)
for i in range(pyramid_heights[5]):
    pyramid5_y_ratios.append((i * y_ratios[4]) >> 16)

pyramid6_x_ratios = []
pyramid6_y_ratios = []
for i in range(pyramid_widths[6]):
    pyramid6_x_ratios.append((i * x_ratios[5]) >> 16)
for i in range(pyramid_heights[6]):
    pyramid6_y_ratios.append((i * y_ratios[5]) >> 16)

pyramid7_x_ratios = []
pyramid7_y_ratios = []
for i in range(pyramid_widths[7]):
    pyramid7_x_ratios.append((i * x_ratios[6]) >> 16)
for i in range(pyramid_heights[7]):
    pyramid7_y_ratios.append((i * y_ratios[6]) >> 16)

pyramid8_x_ratios = []
pyramid8_y_ratios = []
for i in range(pyramid_widths[8]):
    pyramid8_x_ratios.append((i * x_ratios[7]) >> 16)
for i in range(pyramid_heights[8]):
    pyramid8_y_ratios.append((i * y_ratios[7]) >> 16)

pyramid9_x_ratios = []
pyramid9_y_ratios = []
for i in range(pyramid_widths[9]):
    pyramid9_x_ratios.append((i * x_ratios[8]) >> 16)
for i in range(pyramid_heights[9]):
    pyramid9_y_ratios.append((i * y_ratios[8]) >> 16)


num_stage = 0
num_feature = 0
window_size = 0
stage_num_feature = []

rectangle1_xs = []
rectangle1_ys = []
rectangle1_widths = []
rectangle1_heights = []
rectangle1_weights = []

rectangle2_xs = []
rectangle2_ys = []
rectangle2_widths = []
rectangle2_heights = []
rectangle2_weights = []

rectangle3_xs = []
rectangle3_ys = []
rectangle3_widths = []
rectangle3_heights = []
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
for item in root.findall("./cascade/stages/_/stageThreshold"):
    stage_threshold.append(int(round(STAGE_SCALE * (0.4 * float(item.text)))))

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
            rectangle1_xs.append(texts[0])
            rectangle1_ys.append(texts[1])
            rectangle1_widths.append(texts[2])
            rectangle1_heights.append(texts[3])
            rectangle1_weights.append(texts[4])
        elif (rect_index == 1):
            rectangle2_xs.append(texts[0])
            rectangle2_ys.append(texts[1])
            rectangle2_widths.append(texts[2])
            rectangle2_heights.append(texts[3])
            rectangle2_weights.append(texts[4])
        else:
            rectangle3_xs.append(texts[0])
            rectangle3_ys.append(texts[1])
            rectangle3_widths.append(texts[2])
            rectangle3_heights.append(texts[3])
            rectangle3_weights.append(texts[4])

        rect_index += 1

    assert(rect_index == 2 or rect_index == 3)
    if (rect_index == 2):
        rectangle3_xs.append(0)
        rectangle3_ys.append(0)
        rectangle3_widths.append(0)
        rectangle3_heights.append(0)
        rectangle3_weights.append(0)


assert(len(stage_threshold) == num_stage)
assert(len(feature_threshold) == num_feature)
assert(len(feature_below) == num_feature)
assert(len(feature_above) == num_feature)
assert(len(rectangle1_xs) == num_feature)
assert(len(rectangle1_ys) == num_feature)
assert(len(rectangle1_widths) == num_feature)
assert(len(rectangle1_heights) == num_feature)
assert(len(rectangle1_weights) == num_feature)
assert(len(rectangle2_xs) == num_feature)
assert(len(rectangle2_ys) == num_feature)
assert(len(rectangle2_widths) == num_feature)
assert(len(rectangle2_heights) == num_feature)
assert(len(rectangle2_weights) == num_feature)
assert(len(rectangle3_xs) == num_feature)
assert(len(rectangle3_ys) == num_feature)
assert(len(rectangle3_widths) == num_feature)
assert(len(rectangle3_heights) == num_feature)
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

def write_array(arr):
    arr_len = len(arr)
    weights_file.write("{")
    for s in range(arr_len - 1, -1, -1):
        val = arr[s]
        if (val < 0): val += 2**32

        weights_file.write("32'd%d"%(val))
        if (s != 0):
            weights_file.write(",")
    weights_file.write("}")

def write_array_body(arr, arr_name):
    arr_len = len(arr)
    weights_file.write("`define %s "%(arr_name))
    write_array(arr)
    weights_file.write("\n")

## write data
write_array_body(pyramid_widths, "pyramid_widths".upper())
write_array_body(pyramid_heights, "pyramid_heights".upper())
weights_file.write("\n")

write_array_body(pyramid1_x_ratios, "pyramid1_x_ratios".upper())
write_array_body(pyramid1_y_ratios, "pyramid1_y_ratios".upper())
write_array_body(pyramid2_x_ratios, "pyramid2_x_ratios".upper())
write_array_body(pyramid2_y_ratios, "pyramid2_y_ratios".upper())
write_array_body(pyramid3_x_ratios, "pyramid3_x_ratios".upper())
write_array_body(pyramid3_y_ratios, "pyramid3_y_ratios".upper())
write_array_body(pyramid4_x_ratios, "pyramid4_x_ratios".upper())
write_array_body(pyramid4_y_ratios, "pyramid4_y_ratios".upper())
write_array_body(pyramid5_x_ratios, "pyramid5_x_ratios".upper())
write_array_body(pyramid5_y_ratios, "pyramid5_y_ratios".upper())
write_array_body(pyramid6_x_ratios, "pyramid6_x_ratios".upper())
write_array_body(pyramid6_y_ratios, "pyramid6_y_ratios".upper())
write_array_body(pyramid7_x_ratios, "pyramid7_x_ratios".upper())
write_array_body(pyramid7_y_ratios, "pyramid7_y_ratios".upper())
write_array_body(pyramid8_x_ratios, "pyramid8_x_ratios".upper())
write_array_body(pyramid8_y_ratios, "pyramid8_y_ratios".upper())
write_array_body(pyramid9_x_ratios, "pyramid9_x_ratios".upper())
write_array_body(pyramid9_y_ratios, "pyramid9_y_ratios".upper())
weights_file.write("\n")

# number of features in each stage
write_array_body(stage_num_feature, "stage_num_feature".upper())
weights_file.write("// thresholds are negative values\n")
write_array_body(stage_threshold, "stage_threshold".upper())

write_array_body(rectangle1_xs, "rectangle1_xs".upper())
write_array_body(rectangle1_ys, "rectangle1_ys".upper())
write_array_body(rectangle1_widths, "rectangle1_widths".upper())
write_array_body(rectangle1_heights, "rectangle1_heights".upper())
write_array_body(rectangle1_weights, "rectangle1_weights".upper())

write_array_body(rectangle2_xs, "rectangle2_xs".upper())
write_array_body(rectangle2_ys, "rectangle2_ys".upper())
write_array_body(rectangle2_widths, "rectangle2_widths".upper())
write_array_body(rectangle2_heights, "rectangle2_heights".upper())
write_array_body(rectangle2_weights, "rectangle2_weights".upper())

write_array_body(rectangle3_xs, "rectangle3_xs".upper())
write_array_body(rectangle3_ys, "rectangle3_ys".upper())
write_array_body(rectangle3_widths, "rectangle3_widths".upper())
write_array_body(rectangle3_heights, "rectangle3_heights".upper())
write_array_body(rectangle3_weights, "rectangle3_weights".upper())

write_array_body(feature_threshold, "feature_threshold".upper())
write_array_body(feature_above, "feature_above".upper())
write_array_body(feature_below, "feature_below".upper())
