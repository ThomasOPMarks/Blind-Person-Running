from Queue import Queue 
from time import sleep
from threading import Thread


def removeFromQueue(n):
	print(n.get())
	
def putInQueue(n):
	for i in range(10):
		n.put(i)
		
print("Here")
n = Queue()
print("Here 2")

a = Thread(target =  putInQueue, args = (n,))
b = Thread(target =  removeFromQueue, args = (n,))

a.start()
b.start()

a.join()
b.join()

print("Here 3")
