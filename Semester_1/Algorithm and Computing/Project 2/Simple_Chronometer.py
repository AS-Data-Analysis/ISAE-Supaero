# This code has been built using the table logic suggested for the Enhanced chronometer code

from microbit import *

duration = 0.0
currentTime = 0.0
state = 0


def runChrono(): 
    global state, currentTime
    state = 1
    currentTime = running_time()
    display.scroll(state)

def stopChrono():
    global state, duration, currentTime
    state = 2
    duration = duration + running_time() - currentTime
    display.scroll(duration)
    
def resetChrono():
    global duration, state
    duration = 0.0
    state = 0
    
def intermediateStopChrono():
    global currentTime, duration
    inter_time = duration + running_time() - currentTime
    display.scroll(inter_time)

def launchChrono():
    global state
    while True:
        if state == 0:
            if button_a.is_pressed():
                runChrono()
            elif button_b.is_pressed():
                resetChrono()
        elif state == 1:
            if button_a.is_pressed():
                stopChrono()
            elif button_b.is_pressed():
                display.scroll("Chrono running")
        else:
            if button_a.is_pressed():
                display.scroll("reset first")
            elif button_b.is_pressed():
                resetChrono()
                
launchChrono()