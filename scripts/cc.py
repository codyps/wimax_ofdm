#! /usr/bin/env python

from collections import deque
from util import hex_str_to_bin_list

def xor(a, b):
    return a ^ b

class CC():
    def __init__(self):
        self.state = deque([0]*6)
        self.out_d = deque()
        self.in_d  = deque()
        self.name = 'cc'

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

def test_block(da_s, ex_s, block):
    print da_s
    print ex_s
    da = hex_str_to_bin_list(da_s)
    ex = hex_str_to_bin_list(ex_s)

    #for in_bit, ex_bit in zip(da, ex):
    out_bits = [0] * 3
    ex_i = 0
    for i in range(0, len(da)):
        in_bit = da[i]
        out_bit = block.proc_bit(in_bit)

        if not (i % 2):
            out_bits[0] = out_bit[0]
            out_bits[1] = out_bit[1]

        else:
            out_bits[2] = out_bit[0]
            ex_bit = ( ex[ex_i], ex[ex_i+1], ex[ex_i+2] )
            ex_i = ex_i + 3
            print "{3}: {0} {1} {2}".format(in_bit, out_bits, ex_bit, block.name)

indata = 'D4_BA_A1_12_F2_74_96_30_27_D4'
outdata = 'EE_C6_A1_CB_7E_04_73_6C_BC_61_95_D3_B7_DF_00'

cc = CC()

test_block(indata, outdata, cc)



