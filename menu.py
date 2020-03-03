import tkinter
from tkinter import *

def startcode():
    print("cool")

#Creating window 
window = Tk()
window.title("Windows on window")
window.configure(background="#FBEFD9")

#Adding gif to the window
mainImage = PhotoImage(file = "giphy.gif")
Label(window, image = mainImage, bg = "white") .grid(row = 0, column = 0, sticky = E)

startbutton = Button(window,text="start",width = 16, background = 'red', fg = 'white', command = startcode)

startbutton.place(x=1,y=1)

#loop the window always
window.mainloop()