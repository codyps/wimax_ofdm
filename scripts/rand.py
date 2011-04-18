#! /usr/bin/env python

from collections import deque

class Rnd():
    def __init__(self, iv):
        self.iv = deque(iv)

    def proc_bit(self, bit):
        x = self.iv[13] ^ self.iv[14]
        self.iv.appendleft(x)
        self.iv.pop()

        return bit ^ x


def hex_str_to_bin_list(hex_str):
    r = []
    for dig in hex_str:
        d = int(dig, 16) 
        for i in range(0, 4):
            b = (d & (1 << (3-i))) >> (3-i)
            r.append(b)

    return r

def test_rnd(iv, da_s, ex_s):
    print da_s
    print ex_s
    da = hex_str_to_bin_list(da_s)
    ex = hex_str_to_bin_list(ex_s)
    print ex
    r = Rnd(iv)

    print "iv: {0}".format(r.iv)
    for in_bit, ex_bit in zip(da, ex):
        out_bit = r.proc_bit(in_bit)

        print "r: {3} {0} {1} {2}".format(out_bit, ex_bit, r.iv, in_bit)


uiuc = 7 # 0111
bsid = 1 # 0001
frame_num = 1 # 0001

indata =  '4529C479AD0F5528AD87'
outdata = 'D4BAA112F274963027D4'
#           BSID        1  1  UIUC        1  FNUM
#           3  2  1  0  x  x  3  2  1  0  x  3  2  1  0
#       LSB 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
test_rnd( [ 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1 ],
    indata, outdata)

#if __name__ == "__main__":
#    from sys import argv
#    iv_s = argv[1]
#    in_s = argv[2]
#    ex_s = argv[3]
#
#    iv = bit_str_to_bin_list(iv_s)

