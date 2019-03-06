import PIL
from PIL import Image

def scaleDown():
	basewidth = 200
	img = Image.open("/Users/andyshen/Desktop/18-500/sample.jpeg")
	wpercent = (basewidth / float(img.size[0]))
	hsize = int((float(img.size[1]) * float(wpercent)))
	img = img.resize((basewidth, hsize), PIL.Image.ANTIALIAS)
	img.save("resized_image.png")

def colorToGrayscale():
	image_file = Image.open("resized_image.png") # open colour image
	img = Image.open('resized_image.png').convert('LA')
	img.save('grayscale.png')

def main():
	scaleDown()
	colorToGrayscale()

if __name__ == "__main__":
    main()
