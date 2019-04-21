# xml parser
import requests
import xml.etree.ElementTree as ET

def get_xml():
    url = "https://raw.githubusercontent.com/opencv/opencv/master/data/haarcascades/haarcascade_frontalface_default.xml"
    resp = requests.get(url)
    with open("vj_weights.xml", "wb") as f:
        f.write(resp.content)

num_stage = 0
num_feature = 0
window_size = 0
stage_num_feature = []
stage_thresh = []
feature_thresh = []
feature_below = []
feature_above = []
rect1_x = []
rect1_y = []
rect1_width = []
rect1_height = []
rect1_weight = []
rect2_x = []
rect2_y = []
rect2_width = []
rect2_height = []
rect2_weight = []
rect3_x = []
rect3_y = []
rect3_width = []
rect3_height = []
rect3_weight = []

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
    stage_num_feature.append(int(item.text))
    num_feature += int(item.text)

for item in root.findall("./cascade/height"):
    window_size = int(item.text)

print("Number of features: " + str(num_feature))

# get stage threshold
for item in root.findall("./cascade/stages/_/stageThreshold"):
    stage_thresh.append(int(round(STAGE_SCALE * (float(item.text)))))

# get feature threshold
count = 0
for item in root.findall("./cascade/stages/_/weakClassifiers/_/internalNodes"):
    texts = item.text.strip().split(" ")
    assert(int(texts[0]) == 0)
    assert(int(texts[1]) == -1)
    assert(int(texts[2]) == count)
    count += 1
    feature_thresh.append(int(round(FEATURE_SCALE * float(texts[-1]))))

# get values to use based on threshold
for item in root.findall("./cascade/stages/_/weakClassifiers/_/leafValues"):
    texts = item.text.strip().split(" ")
    feature_below.append(int(round(STAGE_SCALE * float(texts[0]))))
    feature_above.append(int(round(STAGE_SCALE * float(texts[1]))))


for item in root.iter("rects"):
    rects = []
    count = 0
    for rect in item.iter("_"):
        texts = rect.text.strip().split(" ")
        assert(len(texts) == 5)

        if (count == 0):
            rect1_x.append(int(texts[0]))
            rect1_y.append(int(texts[1]))
            rect1_width.append(int(texts[2]))
            rect1_height.append(int(texts[3]))
            rect1_weight.append(int(round(FEATURE_SCALE * float(texts[4]))))
        elif (count == 1):
            rect2_x.append(int(texts[0]))
            rect2_y.append(int(texts[1]))
            rect2_width.append(int(texts[2]))
            rect2_height.append(int(texts[3]))
            rect2_weight.append(int(round(FEATURE_SCALE * float(texts[4]))))
        else:
            rect3_x.append(int(texts[0]))
            rect3_y.append(int(texts[1]))
            rect3_width.append(int(texts[2]))
            rect3_height.append(int(texts[3]))
            rect3_weight.append(int(round(FEATURE_SCALE * float(texts[4]))))
        count += 1

    assert(count >= 2)
    if (count == 2):
        # set weights to 0 so it doesn't affect calculation
        rect3_x.append(0)
        rect3_y.append(0)
        rect3_width.append(0)
        rect3_height.append(0)
        rect3_weight.append(0)

assert(len(stage_thresh) == num_stage)
assert(len(feature_thresh) == num_feature)
assert(len(feature_below) == num_feature)
assert(len(feature_above) == num_feature)
assert(len(rect1_x) == num_feature)
assert(len(rect1_y) == num_feature)
assert(len(rect1_width) == num_feature)
assert(len(rect1_height) == num_feature)
assert(len(rect1_weight) == num_feature)
assert(len(rect2_x) == num_feature)
assert(len(rect2_y) == num_feature)
assert(len(rect2_width) == num_feature)
assert(len(rect2_height) == num_feature)
assert(len(rect2_weight) == num_feature)
assert(len(rect3_x) == num_feature)
assert(len(rect3_y) == num_feature)
assert(len(rect3_width) == num_feature)
assert(len(rect3_height) == num_feature)
assert(len(rect3_weight) == num_feature)

def write_array(arr):
    arr_len = len(arr)
    weights_file.write("{")
    for s in range(arr_len):
        val = arr[s]
        weights_file.write("%d"%(val))
        if (s != arr_len - 1):
            weights_file.write(",")
    weights_file.write("};")

def write_array_body(arr, arr_name, arr_type):
    arr_len = len(arr)
    weights_file.write("static %s %s[%d] = "%(arr_type, arr_name, arr_len))
    write_array(arr)
    weights_file.write("\n")

weights_file = open("vj_weights.h", mode="wb")

# .h header comments
weights_file.write("/** @file  vj_weights.h\n")
weights_file.write(" *  @brief Viola-Jones weights data structure\n")
weights_file.write(" */\n\n")

# #include statements
weights_file.write("#ifndef __VJ_WEIGHTS_H_\n")
weights_file.write("#define __VJ_WEIGHTS_H_\n\n")

weights_file.write("// assume we use haarcascade_frontalface_default.xml\n")
weights_file.write("#define NUM_STAGE {num_stage}\n".format(num_stage=num_stage))
weights_file.write("#define NUM_FEATURE {num_feature}\n".format(num_feature=num_feature))
weights_file.write("#define WINDOW_SIZE {window_size}\n\n".format(window_size=window_size))

# number of features in each stage
write_array_body(stage_num_feature, "stage_num_feature".upper(), "unsigned int")
weights_file.write("// thresholds can be negative\n")
write_array_body(stage_thresh, "stage_thresh".upper(), "int")
weights_file.write("\n")

write_array_body(rect1_x, "rect1_x".upper(), "unsigned int")
write_array_body(rect1_y, "rect1_y".upper(), "unsigned int")
write_array_body(rect1_width, "rect1_width".upper(), "unsigned int")
write_array_body(rect1_height, "rect1_height".upper(), "unsigned int")
write_array_body(rect1_weight, "rect1_weight".upper(), "int")

write_array_body(rect2_x, "rect2_x".upper(), "unsigned int")
write_array_body(rect2_y, "rect2_y".upper(), "unsigned int")
write_array_body(rect2_width, "rect2_width".upper(), "unsigned int")
write_array_body(rect2_height, "rect2_height".upper(), "unsigned int")
write_array_body(rect2_weight, "rect2_weight".upper(), "int")

write_array_body(rect3_x, "rect3_x".upper(), "unsigned int")
write_array_body(rect3_y, "rect3_y".upper(), "unsigned int")
write_array_body(rect3_width, "rect3_width".upper(), "unsigned int")
write_array_body(rect3_height, "rect3_height".upper(), "unsigned int")
write_array_body(rect3_weight, "rect3_weight".upper(), "int")

write_array_body(feature_thresh, "feature_thresh".upper(), "int")
write_array_body(feature_above, "feature_above".upper(), "int")
write_array_body(feature_below, "feature_below".upper(), "int")
weights_file.write("\n")

weights_file.write("#endif  /* __VJ_WEIGHTS_H_ */")
