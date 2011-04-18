
from collections import deque

def xor(a, b)
    return a ^ b

class CC():
    def __init__(self):
        self.state = deque([0]*6)
        self.out_d = deque()
        self.in_d  = deque()

    def X(self): 
        s = self.state
        b = [0,1,2,3,6]
        e = [ s[i] for i in b]
        return reduce(xor, e)

    def Y(self):
        s = self.state
        b = [0,2,3,5,6]
        e = [ s[i] for i in b]
        return reduce(xor, e)

    def proc_bit(self, bit):
        self.in_d.appendleft(bit)

        self.state.appendleft(bit)
        r = (self.X(), self.Y())
        self.state.pop()

        self.out_d.appendleft(r[0])
        self.out_d.appendleft(r[1])

        return r

