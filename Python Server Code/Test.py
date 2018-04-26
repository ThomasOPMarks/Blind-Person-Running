#from queue import Queue
#
#from Test2 import Test
#
#a = Queue()
#
#for i in range(10):
#    a.put(i)
#
#a.put("Hi")
#a.put(True)
#a.put(None)
#a.put([1,2,3])
#
#for _ in range(14):
#    print(a.get())

class interface1 :
    def function1(self):
        pass
    
class interface2 :
    def function2(self):
        pass
    
class actual(interface1, interface2):
    def __init__(self):
        self.f = 4
    
    def function1(self):
        return 0
    
    
class Section:
    TOP = 1
    BOT = 2
    LEFT = 3
    RIGHT = 4
    
print(Section.LEFT)
