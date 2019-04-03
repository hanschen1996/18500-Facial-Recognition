import serial
import sys
from PIL import Image

img = Image.open('image.png').convert('LA')
img.save('greyscale.png')

# request to send = rts
# clear to send = cts
# DONT FORGET TO SEND TWO DUMMY BYTES AFTER LAPTOP IMAGE

with open("greyscale.png", "rb") as image:
  f = image.read()
  b = bytearray(f)

ser = serial.Serial(port='COM3', baudrate=921600, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE)
ser.close()
ser.open()
ser.write(b'hi')
print("wrote hi")
print("recieved: " + str(ser.read(10000)))
ser.close()
# ser.getSupportedBaudRates()