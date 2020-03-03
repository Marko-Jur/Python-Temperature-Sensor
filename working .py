import time
import serial
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import sys, time, math
import tkinter
import pygame

COLOUR = 'red'

def startcode():
    ser = serial.Serial(
    port='COM5',
    baudrate=115200,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_TWO,
    bytesize=serial.EIGHTBITS
    )

    ser.isOpen()


    def data_gen():
        t = data_gen.t

        while True:
            t+=1
            strin = ser.read(2)
            numberforchart = int(strin.decode())
            print(numberforchart)

            yield t, numberforchart

    def run(data):
        # update the data
        t,y = data
        if t>-1:
            xdata.append(t)
            ydata.append(y)
            if t>xsize: # Scroll to the left.
                ax.set_xlim(t-xsize, t)
            line.set_data(xdata, ydata)
        return line,

    def on_close_figure(event):
        sys.exit(0)
    # configure the serial port


    while 1 :
        #print(numberforchart)

        xsize=100    
        data_gen.t = -1
        fig = plt.figure()
        fig.canvas.mpl_connect('close_event', on_close_figure)
        ax = fig.add_subplot(111)
        line, = ax.plot([], [], lw=2,color = COLOUR)
        ax.set_ylim(-100, 100)
        ax.set_xlim(0, xsize)
        ax.grid()
        xdata, ydata = [], []

        # Important: Although blit=True makes graphing faster, we need blit=False to prevent
        # spurious lines to appear when resizing the stripchart.
        ani = animation.FuncAnimation(fig, run, data_gen, blit=False, interval=100, repeat=False)
        plt.show()



####################################################################################################################################################################################

def redLine():
    global COLOUR
    COLOUR = 'red'
    print("Line is now red")

def blueLine():
    global COLOUR
    COLOUR = 'blue'
    print("Line is now blue")

def yellowLine():
    global COLOUR
    COLOUR = 'yellow'
    print("Line is now yellow")


#Tkinter main menu:
from tkinter import *
#Creating window 
window = Tk()
window.title("Python Temperature Sensor")
window.configure(background="#FBEFD9")

#Adding gif to the window
mainImage = PhotoImage(file = "giphy.gif")
Label(window, image = mainImage, bg = "white") .grid(row = 0, column = 0, sticky = E)

#startbutton
startbutton = Button(window,text="start",width = 16, background = 'red', fg = 'white', command = startcode)
startbutton.place(x=1,y=1)

redbutton = Button(window,text="Red Line",width = 16, background = 'red', fg = 'white', command = redLine)
redbutton.place(x=1,y=50)

yellowbutton = Button(window,text="Yellow Line",width = 16, background = 'red', fg = 'white', command = yellowLine)
yellowbutton.place(x=1,y=100)

bluebutton = Button(window,text="Blue Line",width = 16, background = 'red', fg = 'white', command = blueLine)
bluebutton.place(x=1,y=150)

musicbutton = Button(window,text="Blue Line",width = 16, background = 'red', fg = 'white', command = blueLine)
musicbutton.place(x=1,y=150)


pygame.init()
from pygame import mixer
mixer.init()
#mixer.music.load("C:/Users/Marko/Desktop/tryna get it/backgroundarcade.mp3")
#mixer.music.play()




#loop the window always
window.mainloop()

#####################################################################################################################################################################################