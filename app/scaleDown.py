import PIL
from PIL import Image

def scaleDown():
    basewidth = 160
    baseheight= 120

    img = Image.open("image.png")
    wpercent = (basewidth / float(img.size[0]))
    hsize = int((float(img.size[1]) * float(wpercent)))
    img = img.resize((basewidth, baseheight), PIL.Image.NEAREST)
    img.save("resized_image.png")

def colorToGrayscale():
    image_file = Image.open("resized_image.png") # open colour image
    img_orig = Image.open('resized_image.png')
    print(img_orig.size)
    img = Image.open('resized_image.png').convert('L')
    print(img.size)
    img.save('image.pgm')
    

def main():
    scaleDown()
    colorToGrayscale()

if __name__ == "__main__":
    main()
