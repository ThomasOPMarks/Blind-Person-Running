# -*- coding: utf-8 -*-
"""
Created on Thu Mar  8 19:25:30 2018

@author: Thomas Marks
"""

from math import sqrt
from math import atan
from math import pi

class Section:
    TOP = 1
    BOT = 2
    LEFT = 3
    RIGHT = 4

class PWMPair:
    def __init__(self, leftx, rightx):
        self.left = leftx
        self.right = rightx


class GPSCoord:
    def __init__(self, MMC):
        self.number = MMC[0]
        self.x = MMC[1]
        self.y = MMC[2]
        self.z = MMC[3]
        self.timeStamp = MMC[4]
    def __lt__(self, other):
        return self.timeStamp < other.timeStamp
    def __eq__(self, other):
        return self.timeStamp == other.timeStamp
    def __mul__(self, other):
        return sqrt((self.x - other.x) ** 2 + (self.y - other.y) ** 2)
    def __pow__(self, other):
        return [(self * other) / abs(self.timeStamp - other.timeStamp), abs(self.timeStamp - other.timeStamp)]


class Track:
    def __init__(self, lane, GPSQueue, SendQueue, PWMQueue, Reverse):
        self.GPSQueue = GPSQueue
        self.SendQueue = SendQueue
        self.straight = 84.39
        self.trackWidth = 1.22
        self.Radius = 36.50
        self.innerRadius = 36.50 + self.trackWidth * (lane - 1)
        self.outterRadius = self.innerRadius + self.trackWidth
        self.topOfTop = - self.trackWidth * lane
        self.botOfTop = -self.trackWidth * (lane - 1)
        self.topOfBot = 73 * self.trackWidth * (lane - 1)
        self.botOfBot = self.topOfBot + self.trackWidth
        self.PWMQueue = PWMQueue
        self.Reverse = Reverse
        self.xOffset = 0
        self.yOffset = 0
        self.r = 0
        self.i = 0
        self.distance = 0
    def update(self):
        currentGPS = GPSCoord([0,0,0,0, 0])
        while True:
            self.i = self.i + 1
            secondGPS = currentGPS
            currentGPS = self.GPSQueue.get()
            if(currentGPS.number == -1):
                self.SendQueue.put("Quit")
                self.PWMQueue.put(PWMPair(-1,-1))
                break
            else:
                self.distance = self.distance + currentGPS * secondGPS
                self.__updateSelf(currentGPS, self.PWMQueue)
                if self.i % 15 == 0:
                    self.i = 0
                    self.SendQueue.put(str(round(self.distance/1000, 2)))
        print('Broke out of update thread')
                
                
                
    def __updateSelf(self, currentGPS, PWMQueue):
        #TODO Make actual logic via test
        section = self.sectionGetter(currentGPS)
        x = currentGPS.x
        y = currentGPS.y
#        #THIS IS FOR DEMO FRIDAY THE 18TH!
#        if(currentGPS.y < -1.96):
#            left = 100
#            right = 0
#            print('Right buzz')
#            f = open('dataouts.txt','a')
#            f.write('Right buzz\n')
#            f.close()
#        elif(currentGPS.y > -0.51): 
#            left = 0
#            right = 100
#            print('Left buzz')
#            f = open('dataouts.txt','a')
#            f.write('Left buzz\n')
#            f.close()
#        else:
#            left = 0
#            right = 0
#        if self.Reverse[0]:
#            PWMQueue.put(PWMPair(left, right))
#        else:
#            PWMQueue.put(PWMPair(right, left))
        
        #FOR NORMAL WHOLE TRACK
        if section == Section.TOP:
            if y - self.yOffset > -.11 - self.r * self.trackWidth :
                left = 100
                right = 0
            elif y - self.yOffset < -1.11 - self.r * self.trackWidth:
                right = 100
                left = 0
            else:
                left = 0
                right = 0
        elif section == Section.BOT:
            if y - self.yOffset < 73.0 + 0.11 + self.r * self.trackWidth:
                left = 100
                right = 0
            elif y - self.yOffset > 73.0 + 1.11 + self.r * self.trackWidth:
                right = 100
                left = 0
            else:
                left = 0
                right = 0
        elif section == Section.LEFT:
            distance = sqrt((x - self.xOffset) ** 2 + (y - self.yOffset - self.Radius))
            if distance < self.Radius + .11:
                left = 100
                right = 0
            elif distance > self.Radius + 1.11:
                right = 100
                left = 0
            else:
                left = 0
                right = 0
        elif section == Section.RIGHT:
            distance = sqrt((x - self.xOffset - self.straight) ** 2 + (y - self.yOffset - self.Radius))
            if distance < self.Radius + .11:
                left = 100
                right = 0
            elif distance > self.Radius + 1.11:
                right = 100
                left = 0
            else:
                left = 0
                right = 0
        if self.Reverse[0]:
            PWMQueue.put(PWMPair(left, right))
        else:
            PWMQueue.put(PWMPair(right, left))
    
    #Determines what section of the track the user is in
    def sectionGetter(self, coord):
        x = coord.x 
        y = coord.y 
        if(x - self.xOffset < 0):
            return Section.LEFT
        elif x - self.xOffset > self.straight:
            return Section.RIGHT
        elif y - self.yOffset > self.Radius:
            return Section.BOT
        else:
            return Section.TOP
                
                
                
                
                




#Used to make sure the correct angle is returned from the two coordinates passed
def bearingFinder(coord1, coord2):
    x1 = coord1.x
    x2 = coord2.x
    y1 = coord1.y
    y2 = coord2.y
    if(x2 > x1):
        return atan((y2 - y1)/(x2 - x1))
    else:
        return atan((y2 - y1)/(x2 - x1)) - pi
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
