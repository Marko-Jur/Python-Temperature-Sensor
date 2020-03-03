import time
import serial
import tkinter

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import sys, time, math


# configure the serial port
ser = serial.Serial(
    port='COM5',
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_TWO,
    bytesize=serial.EIGHTBITS
)

ser.isOpen()

while 1 :
    strin = ser.readline().strip().decode()
    strin = int(strin)
   