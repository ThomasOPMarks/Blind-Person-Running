# -*- coding: utf-8 -*-
"""
Created on Sun Mar 11 17:46:19 2018

@author: Thomas Marks
"""

class Test:
    def __init__(self, a):
        self.a = a
    def double(self):
        self.a = testFunction(self.a)
    
def testFunction(a):
    return 2 * a

a = Test(2)
a.double()
