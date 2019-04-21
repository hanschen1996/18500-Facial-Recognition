import serial
import sys
from PIL import Image
import time
import os

# request to send = rts
# clear to send = cts
# DONT FORGET TO SEND TWO DUMMY BYTES AFTER LAPTOP IMAGE

img = Image.open('subject01.gif.pgm').convert('L')
WIDTH, HEIGHT = img.size
data = list(img.getdata())
data = [data[offset:offset+WIDTH] for offset in range(0, WIDTH*HEIGHT, WIDTH)]

ser = serial.Serial(port='COM3', baudrate=921600, bytesize=serial.EIGHTBITS, parity=serial.PARITY_NONE, stopbits=serial.STOPBITS_ONE, timeout=1)
ser.close()
ser.open()
input("port opened")

i = 0
j = 0
k = 0
no_break = True
# while (i < HEIGHT and no_break):
#     while (j < WIDTH and no_break):
#         assert(ser.write(bytes([data[i][j]])))
#         time.sleep(1)
#         # print(ser.read())
#         # no_break = input("exit?") != "y"
#         j += 1
#         k += 1
#     print("wrote row", i)
#     i += 1
#     j = 0
#     if (input("write another row?") == "n"):
#         break
to_send = bytes([data[0][0]])
for i in range(HEIGHT):
    for j in range(WIDTH):
        if (i+j != 0): to_send += bytes([data[i][j]])
assert(ser.write(to_send) == 19200)

# while (True):
#     if (input("send another?") == "n"):
#         break
#     assert(ser.write(bytes([240])))
#     k += 1
# print("k =", k)

while (no_break):
    coords = []
    for i in range(5):
        a = ser.read()
        if len(a) == 0:
            coords.append("NULL")
        else:
            coords.append(ord(a))
    print(coords)
    time.sleep(1)
    no_break = input("keep going?") != "n"

ser.close()
