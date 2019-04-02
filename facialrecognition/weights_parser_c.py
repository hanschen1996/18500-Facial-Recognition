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
feature_below_val = []
feature_above_val = []
feature_rects = []

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
    feature_below_val.append(int(round(STAGE_SCALE * float(texts[0]))))
    feature_above_val.append(int(round(STAGE_SCALE * float(texts[1]))))


for item in root.iter("rects"):
    rects = []
    for rect in item.iter("_"):
        texts = rect.text.strip().split(" ")
        assert(len(texts) == 5)
        texts = [int(texts[0]), int(texts[1]), int(texts[2]), int(texts[3]), int(round(FEATURE_SCALE * float(texts[4])))]
        rects.append(texts)
    if (len(rects) == 2):
        # set weights to 0 so it doesn't affect calculation
        rects.append([0, 0, 0, 0, 0])
    assert(len(rects) == 3)
    feature_rects.append(rects)

assert(len(stage_thresh) == num_stage)
assert(len(feature_thresh) == num_feature)
assert(len(feature_below_val) == num_feature)
assert(len(feature_above_val) == num_feature)
assert(len(feature_rects) == num_feature)

weights_file = open("inc/vj_weights.h", mode="wb")

# .h header comments
weights_file.write("/** @file inc/vj_weights.h\n")
weights_file.write(" *  @brief Viola-Jones weights data structure\n")
weights_file.write(" */\n\n")

# #include statements
weights_file.write("#ifndef __INC_VJ_WEIGHTS_H_\n")
weights_file.write("#define __INC_VJ_WEIGHTS_H_\n\n")
weights_file.write('#include "vj_types.h"\n\n')

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

# write data
weights_file.write("static const Stage STAGES[NUM_STAGE] = {\n")
for s in range(num_stage):
    struct_field = ".feature_count={count}, .threshold={thresh}".format(count=stage_num_feature[s], thresh=stage_thresh[s])
    if (s == num_stage-1):
        weights_file.write("    {" + struct_field + "}\n};\n")
    else:
        weights_file.write("    {" + struct_field + "},\n")

weights_file.write("\n")

# write feature information
weights_file.write("static const Feature FEATURES[NUM_FEATURE] = {\n")
for f in range(num_feature):
    rect1 = ".x={x}, .y={y}, .width={width}, .height={height}, .weight={weight}".format(x=feature_rects[f][0][0],
       y=feature_rects[f][0][1],
       width=feature_rects[f][0][2],
       height=feature_rects[f][0][3],
       weight=feature_rects[f][0][4])
    rect2 = ".x={x}, .y={y}, .width={width}, .height={height}, .weight={weight}".            format(x=feature_rects[f][1][0],
       y=feature_rects[f][1][1],
       width=feature_rects[f][1][2],
       height=feature_rects[f][1][3],
       weight=feature_rects[f][1][4])
    rect3 = ".x={x}, .y={y}, .width={width}, .height={height}, .weight={weight}".            format(x=feature_rects[f][2][0],
       y=feature_rects[f][2][1],
       width=feature_rects[f][2][2],
       height=feature_rects[f][2][3],
       weight=feature_rects[f][2][4])
    rect1 = "{" + rect1 + "}"
    rect2 = "{" + rect2 + "}"
    rect3 = "{" + rect3 + "}"
    feature_str = ".rect1={rect1}, .rect2={rect2}, .rect3={rect3}, .below={below}, .above={above}, .threshold={threshold}".format(rect1=rect1,
                                              rect2=rect2,
                                              rect3=rect3,
                                              below=feature_below_val[f],
                                              above=feature_above_val[f],
                                              threshold=feature_thresh[f])
    if (f == num_feature-1):
        weights_file.write("    {" + feature_str + "}\n};\n")
    else:
        weights_file.write("    {" + feature_str + "},\n")

weights_file.write("#endif  /* __INC_VJ_WEIGHTS_H_ */")

#for i in range(10):
#    print(feature_rects[i])
#print(stage_thresh)
#print(feature_thresh)
#print(feature_below_val)
#print(feature_above_val)
