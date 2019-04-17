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

pyramid_widths = [160, 133, 111, 92, 77, 64, 53, 44, 37]
pyramid_heights = [120, 99, 83, 69, 57, 48, 40, 33, 27]

x_mappings = [78841, 94467, 113976, 136179, 163841, 197845, 238313, 283399]
y_mappings = [79438, 94751, 113976, 137971, 163841, 196609, 238313, 291272]

pyramid_x_mappings = []
pyramid_y_mappings = []
for i in range(len(x_mappings)):
    curr_x_mappings = []
    curr_y_mappings = []
    for j in range(pyramid_widths[0]):
        curr_x_mappings.append((j * x_mappings[i]) >> 16)
    assert(len(curr_x_mappings) == pyramid_widths[0])

    for j in range(pyramid_heights[0]):
        curr_y_mappings.append((j * y_mappings[i]) >> 16)
    assert(len(curr_y_mappings) == pyramid_heights[0])

    pyramid_x_mappings.append(curr_x_mappings)
    pyramid_y_mappings.append(curr_y_mappings)


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

def write_coe(arr, arr_name):
    coe_file = open("%s.coe"%(arr_name), mode="wb")
    coe_file.write("memory_initialization_radix=10;\n")
    coe_file.write("memory_initialization_vector=\n")
    for i in range(len(arr)):
        if (i == len(arr) - 1):
            coe_file.write("%d;"%(arr[i]))
        else:
            coe_file.write("%d,\n"%(arr[i]))
    coe_file.close()

write_coe(rectangle1_x1, "rectangle1_x1")
write_coe(rectangle1_y1, "rectangle1_y1")
write_coe(rectangle1_x2, "rectangle1_x2")
write_coe(rectangle1_y2, "rectangle1_y2")
write_coe(rectangle1_weights, "rectangle1_weights")

write_coe(rectangle2_x1, "rectangle2_x1")
write_coe(rectangle2_y1, "rectangle2_y1")
write_coe(rectangle2_x2, "rectangle2_x2")
write_coe(rectangle2_y2, "rectangle2_y2")
write_coe(rectangle2_weights, "rectangle2_weights")

write_coe(rectangle3_x1, "rectangle3_x1")
write_coe(rectangle3_y1, "rectangle3_y1")
write_coe(rectangle3_x2, "rectangle3_x2")
write_coe(rectangle3_y2, "rectangle3_y2")
write_coe(rectangle3_weights, "rectangle3_weights")

write_coe(feature_threshold, "feature_threshold")
write_coe(feature_above, "feature_above")
write_coe(feature_below, "feature_below")
write_coe(stage_threshold, "stage_threshold")

write_coe(is_stage_end, "is_stage_end")
