# -*- coding: utf-8 -*-
"""
Created on Thu Mar  8 19:22:50 2018

@author: Thomas Marks
"""

#  
import RPi.GPIO as GPIO
import socket
from time import sleep
from threading import Thread
from queue import Queue
from marvelmind import MarvelmindHedge
from GPSObject import GPSCoord
from GPSObject import Track



def PMWFunction(PWMQueue):
    GPIO.setmode(GPIO.BOARD)

    #pins 12 and 32 are the only pwms
    GPIO.setup(12, GPIO.OUT)
    pwm1= GPIO.PWM(12, 100)
    GPIO.setup(32, GPIO.OUT)
    pwm2= GPIO.PWM(32, 100)
    
    #hedge = MarvelmindHedge(tty = "/dev/ttyACM0", adr=10, debug=False) # create MarvelmindHedge thread
    #hedge.start() 
    
    # main loop of the program
    print("\nPress Ctl C to quit \n")
    #text = raw_input("prompt: ")  # Python 2
    #right now it is just taking in input from user can change this
    #to whatever
    #text = float(input("prompt: "))  # Python 3
    dc1=0
    dc2=0
    pwm1.start(dc1)
    pwm2.start(dc2)
    #threshold = 20; #can't feel anything under 20
    
    currentPair = PWMQueue.get()
    while currentPair.left != -1:
        pwm1.ChangeDutyCycle(currentPair.left)
        pwm2.ChangeDutyCycle(currentPair.right)
        currentPair = PWMQueue.get()
        
    
    
    pwm1.stop()
    pwm2.stop()
    GPIO.cleanup()

def marvelThread(status, GPSQueue):
    hedge = MarvelmindHedge(tty = "/dev/ttyACM0", adr=10, debug=False) # create MarvelmindHedge thread
    hedge.start() # start thread
    while status[0]:
            sleep(.1)            
            #Number of beacon, X, Y, Z, Time
            GPSQueue.add(GPSCoord(hedge.position()))
            print ("The Marvel Thread: ", '')
            hedge.print_position()
    if not status[0]:
        GPSQueue.add("Quit")
    
            
def read(c, marvel):
    #receive for a while
    while(True):
        #print statement for debugging
        print("Receiving Thread")
        #receive data (blocking, so thread can yeild if there is nothing here)
        data = c.recv(1024)
        #print for debugging
        print(data)
        #If the data was the quit message, break out and signal to marvel to end
        if(data == "Quit"):
            marvel[0] = False
            break

def send(c, SendQueue):
    #Print for the debugging 
    print("s")
    #Keep sending until
    while(True):
        #If there is no work in the work queue sleep for a second
        if(SendQueue.empty()):
            sleep(1)
            continue
        try: #try block because could throw a socket error
            #pull a send message from the queue
            sendMessage = SendQueue.get()
            #If it was quit (from the update thread because it quit)
            if(sendMessage == "Quit"):
                print("In the sending thread Quit")
                c.send("Quit")
                break
            #Otherwise send the message
            print("In the sending thread")
            c.send(sendMessage)
        except socket.error: #catch the error, and just print it happened
            print("Couldn't send anything")
            
def update(GPSQueue, SendQueue, PWMQueue):
    #Make a track object, and update it (it takes care of updating itself)
    track = Track(1, GPSQueue, SendQueue, PWMQueue)
    track.update()


def main():
    data = ""
    while(data != "Quit"):
        GPSQueue = Queue()
        SendQueue = Queue()
        PWMQueue = Queue()
        
        mysocket = socket.socket()
        host = socket.gethostbyname(socket.getfqdn())
        port = 9876
        
        if host == "127.0.1.1":
            import commands
            host = commands.getoutput("hostname -I")
            print ("host = " + host)
        
        #Prevent Addresss already in use socket error
        mysocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        
        mysocket.bind((host, port))
        
        mysocket.listen(2) #number of queued connections the socket should have (max is typically five)
        
        c, addr = mysocket.accept()
        
        
        
        # A list, that is the condition for the coordinates loop (modified by receive, read by marvel)
        marvelOK = [True]

        #receiving thread
        r = Thread(target = read, args = (c, marvelOK,))
        #sending thread
        s = Thread(target = send, args = (c, SendQueue,))
        #marvel thread
        m = Thread(target = marvelThread, args = (marvelOK, GPSQueue,))
        #Update thread
        u = Thread(target = update, args = (GPSQueue, SendQueue, PWMQueue,))
        #PWM Queue
        p = Thread(target = PMWFunction, args = (PWMQueue,))
        
        #Start all the threads
        r.start()
        m.start()
        u.start()
        s.start()
        p.start()
        #Wait for them to all finish
        r.join()
        m.join()
        u.join()
        s.join()
        p.join()
        print("Server stopped for that session")
        c.close()
        #After this it once again starts the server, waiting for a new connection (we're in a while true)

if __name__ == '__main__':
    main()