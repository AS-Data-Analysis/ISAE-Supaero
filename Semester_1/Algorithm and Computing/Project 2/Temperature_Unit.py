from microbit import *

def Fahrenheit():
    display.scroll((9/5)*(temperature())+32)

while True:
    if button_a.is_pressed():
        display.scroll(temperature())
    elif button_b.is_pressed():
        Fahrenheit()