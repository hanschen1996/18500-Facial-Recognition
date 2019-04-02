import PIL
from PIL import Image
import os

def scaleDown():
    basewidth = 160
    baseheight= 120

    cwd = os.getcwd()
    print(cwd)
    
    img = Image.open("/Users/andyshen/Downloads/image.png")
    wpercent = (basewidth / float(img.size[0]))
    hsize = int((float(img.size[1]) * float(wpercent)))
    img = img.resize((basewidth, baseheight), PIL.Image.NEAREST)
    img.save("/Users/andyshen/Downloads/image.png")

def colorToGrayscale():
    image_file = Image.open("/Users/andyshen/Downloads/image.png") # open colour image
    img = Image.open('/Users/andyshen/Downloads/image.png').convert('L')
    img.save('/Users/andyshen/Downloads/image.pgm')

def main():
    scaleDown()
    colorToGrayscale()

if __name__ == "__main__":
    main()
