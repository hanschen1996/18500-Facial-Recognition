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
    feature_below.append(int(round(FEATURE_SCALE * float(texts[0]))))
    feature_above.append(int(round(FEATURE_SCALE * float(texts[1]))))


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

'''
# #include statements
weights_file.write("#ifndef __INC_VJ_WEIGHTS_H_\n")
weights_file.write("#define __INC_VJ_WEIGHTS_H_\n\n")
weights_file.write('#include "vj_types.h"\n\n')
'''

weights_file.write("// assume we use haarcascade_frontalface_default.xml\n")
weights_file.write("#define NUM_STAGE {num_stage}\n".format(num_stage=num_stage))
weights_file.write("#define NUM_FEATURE {num_feature}\n".format(num_feature=num_feature))
weights_file.write("#define WINDOW_SIZE {window_size}\n\n".format(window_size=window_size))

"""
weights_file.write("static const Stage STAGES[NUM_STAGE];\n")
weights_file.write("static const Feature FEATURES[NUM_FEATURE];\n\n")
weights_file.write("#endif  /* __INC_VJ_WEIGHTS_H_ */")

# .c header comments
weights_file = open("vj_weights.c", mode="wb")
weights_file.write("/** @file vj_weights.c\n")
weights_file.write(" *  @brief Viola-Jones weights data\n")
weights_file.write(" */\n\n")

# #include statements
weights_file.write('#include "inc/vj_types.h"\n\n')
"""

def write_array(arr, arr_len):
    for s in range(arr_len):
        if (s == arr_len - 1):
            weights_file.write("%d};\n"%(arr[s]))
        else:
            weights_file.write("%d, "%(arr[s]))

def write_array_body(arr, arr_name):
    arr_len = len(arr)
    weights_file.write("localparam logic [%d:0][31:0] %s = {"%(arr_len - 1, arr_name))
    write_array(arr, arr_len)
    weights_file.write("\n")

## write data

# number of features in each stage
write_array_body(stage_num_feature, "stage_num_feature")
write_array_body(stage_threshold, "stage_threshold")

write_array_body(rectangle1_xs, "rectangle1_xs")
write_array_body(rectangle1_ys, "rectangle1_ys")
write_array_body(rectangle1_widths, "rectangle1_widths")
write_array_body(rectangle1_heights, "rectangle1_heights")
write_array_body(rectangle1_weights, "rectangle1_weights")

write_array_body(rectangle2_xs, "rectangle2_xs")
write_array_body(rectangle2_ys, "rectangle2_ys")
write_array_body(rectangle2_widths, "rectangle2_widths")
write_array_body(rectangle2_heights, "rectangle2_heights")
write_array_body(rectangle2_weights, "rectangle2_weights")

write_array_body(rectangle3_xs, "rectangle3_xs")
write_array_body(rectangle3_ys, "rectangle3_ys")
write_array_body(rectangle3_widths, "rectangle3_widths")
write_array_body(rectangle3_heights, "rectangle3_heights")
write_array_body(rectangle3_weights, "rectangle3_weights")

write_array_body(feature_threshold, "feature_threshold")
write_array_body(feature_above, "feature_above")
write_array_body(feature_below, "feature_below")

#for i in range(10):
#    print(feature_rects[i])
#print(stage_thresh)
#print(feature_thresh)
#print(feature_below_val)
#print(feature_above_val)
