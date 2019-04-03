import serial
import sys
from PIL import Image

# request to send = rts
# clear to send = cts
# DONT FORGET TO SEND TWO DUMMY BYTES AFTER LAPTOP IMAGE

img = Image.open('image.png').convert('L')
WIDTH, HEIGHT = img.size
data = list(img.getdata())
data = [data[offset:offset+WIDTH] for offset in range(0, WIDTH*HEIGHT, WIDTH)]

ser = serial.Serial(port='COM3', baudrate=921600, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, timeout=None)
ser.close()
ser.open()

for i in range(HEIGHT):
    for j in range(WIDTH):
        ser.write(b"%0.2X" % data[i][j])
ser.write(b"FF")
ser.write(b"FF")

while (True):
    ser.read()
    wait(10)

ser.close()