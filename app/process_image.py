import PIL
from PIL import Image
import os
from subprocess import Popen, PIPE
import nms
import sys

IMG_PATH = "/Users/andyshen/Downloads/image0.png"
PROG_PATH = "/Users/andyshen/Desktop/18500-Facial-Recognition/facialrecognition/vj"
WIDTH = 160
HEIGHT = 120
TMP_OUTPUT = "image0.pgm"
STATIC_OUTPUT = "/Users/andyshen/Desktop/18500-Facial-Recognition/app/identityChecker/static/identityChecker/face_output.png"

def main():
    img = Image.open(IMG_PATH)
    img = img.resize((WIDTH, HEIGHT), PIL.Image.NEAREST)
    img = img.convert('L')
    img.save(TMP_OUTPUT)

    boxes = []
    p = Popen([PROG_PATH, TMP_OUTPUT], stdout=PIPE, stdin=PIPE)

    while (True):
        line = p.stdout.readline()
        line = line.decode().strip()
        if (line == ""): break

        if (line.startswith('Face:(')):
            box = line[len("Face:("):-1].split(",")
            boxes.append(list(map(lambda x: int(x), box)))
        elif (line.startswith("ERROR:")):
            print("No face found!")
            sys.exit(-1)

    results = nms.nms(boxes)
    img_data = img.load()
    for i in range(len(results)):
        (x1,y1,x2,y2,_) = results[i]
        for x in range(x1, x2):
            img_data[x,y1] = 0
            img_data[x,y2] = 0

        for y in range(y1, y2):
            img_data[x1,y] = 0
            img_data[x2,y] = 0

    print("Face found! Image saved in face_output.pgm")
#    img.show()
    img.save(STATIC_OUTPUT)

    # cleanup
    os.remove(TMP_OUTPUT)
    os.remove("%s_detect.pgm"%(TMP_OUTPUT))

if __name__ == "__main__":
    main()