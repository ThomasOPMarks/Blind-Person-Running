import RPi.GPIO as GPIO
import time


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
text = float(input("prompt: "))  # Python 3
dc1=0
dc2=0
pwm1.start(dc1)
pwm2.start(dc2)
threshold = 20; #can't feel anything under 20


while True:
    for dc1 in range(int(text),int(text)+1,5):
        pwm1.ChangeDutyCycle(dc1)
        time.sleep(0.05) #urgency shorter time
        print(dc1)
        if dc1==text:
            text = float(input("prompt: "))
            #print (hedge.position())
    for dc2 in range(int(text),int(text)+1,5):
        pwm2.ChangeDutyCycle(dc2)
        time.sleep(0.05) #urgency shorter time
        print(dc2)
        if dc2==text:
            text = float(input("prompt: "))
            #print (hedge.position())
    


pwm1.stop()
pwm2.stop()
GPIO.cleanup()


