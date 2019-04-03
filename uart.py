import serial
import sys
from PIL import Image

# request to send = rts
# clear to send = cts
# DONT FORGET TO SEND TWO DUMMY BYTES AFTER LAPTOP IMAGE

img = Image.open('image.png').convert('LA')
img.save('greyscale.png')

img = open("greyscale.png", "rb").read()
b = bytearray(img)
print(len(b))

# ser = serial.Serial(port='COM3', baudrate=921600, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE)
# ser.close()
# ser.open()
# ser.write(b'hi')
# print("wrote hi")
# print("recieved: " + str(ser.read(10000)))
# ser.close()
# ser.getSupportedBaudRates()