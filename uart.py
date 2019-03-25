import serial
import sys

ser = serial.Serial('COM3', 9600,timeout=2)
ser.close()
ser.open()
ser.write(b'hi')
print("wrote hi")
print("recieved: " + str(ser.read(10000)))
ser.close()

# Bytes literals are always prefixed with 'b' or 'B'; 
# they produce an instance of the bytes type instead of the str type. 
# They may only contain ASCII characters; bytes with a numeric value of 
# 128 or greater must be expressed with escapes.

#print(sys.getsizeof('hello')) 54
#print(sys.getsizeof(b'hello')) 38