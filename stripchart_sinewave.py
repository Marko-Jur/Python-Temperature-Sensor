import time
import serial
import tkinter
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import sys, time, math
#import pygame

#COLOUR = 'blue'


def startcode():
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
        strin = ser.readline().rstrip().decode()
        #strin = int.from_bytes(strin,byteorder = 'big')
        #int.from_bytes(strin,byteorder = 'big')
        #strin = ser.read(2)
        print(strin)
        #test = int(strin)
        #print(test)
    


    
    

