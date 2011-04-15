#! /usr/bin/env python
# vim: set fileencoding=utf8 :

#  Let Ncpc be the number of coded bits per subcarrier,
#  i.e., 1, 2, 4 or 6 for BPSK, QPSK, 16-QAM, or 64-
#  QAM, respectively. Let s = ceil(Ncpc/2).
# 
#  The first permutation is defined by:
#  m_k = ( N_cbps ⁄ 12 ) ⋅ k mod12 + floor ( k ⁄ 12 ).
#  	k = 0, 1, ..., N_cbps – 1
# 
#  The second permutation is defined by Equation (26).
#  j_k = s ⋅ floor ( m_k ⁄ s ) + ( m_k + N_cbps –
#            floor ( 12 ⋅ m_k ⁄ N_cbps ) ) mod ( s )
#  	k = 0, 1, ..., N_cbps – 1


from math import floor, ceil
import sys

param = {
    'out_var' : 'out_blk',
    'in_var'  : 'inr',
    'mod'     : 'QPSK',
    'subchan' : 8
}


param['subchan'] = int(sys.argv[1])
param['mod']     = sys.argv[2]
which            = sys.argv[3]
warn             = sys.argv[4] == "warn"

if which == "both":
    p_std = p_quick = True
elif which == "std":
    p_std = True
    p_quick = False
elif which == "quick":
    p_std = False
    p_quick = True
else :
    raise Exception()

ncpc_ = {
    'BPSK': 1.0,
    'QPSK': 2.0,
    '16-QAM': 4.0,
    '64-QAM': 6.0
}

ncbps_ = {
        'BPSK':   [192,  96,  48,  24,  12],
        'QPSK':   [384,  192, 96,  48,  24],
        '16-QAM': [768,  384, 192, 96,  48],
        '64-QAM': [1152, 576, 288, 144, 72]
}

subchan_ct = {
        16: 0,
        8:  1,
        4:  2,
        2:  3,
        1:  4
}

ncpc = ncpc_[param['mod']]
ncbps = ncbps_[param['mod']][subchan_ct[param['subchan']]]
s = ceil(ncpc / 2)

m = []

for k in range(0, ncbps):
    m.append((ncbps / 12) * (k % 12) + floor(k / 12));

j = []

for k in range(0, ncbps):
    j.append(s * floor(m[k] / s) + ((m[k] + ncbps - \
        floor(12 * m[k] / ncbps) ) % s))

of = "{out_var}[{k}] <= {in_var}[{in_index}];"
bad = False
for k in range(0, ncbps):
    i1 = int(j[int(k)])
    i2 = ((k % 12) * ncbps / 12) + (int(k / 12))
    
    if (i1 != i2):
        if (warn):
            print "omg: k = {0}, {1} != {2}".format(k, i1, i2)
        bad = True

    if (p_std):
        print of.format(k = k, in_index = i1, **param)

    if (p_quick):
        print of.format(k = k, in_index = i2, **param)

if bad:
    print "omg"

#for x in range(0, ncbps, 12):
#    for y in range(0, 12):
#        k = x + y
#        ii = (y * ncbps / 12) + (x / 12)
#        print of.format(k = k, in_index = ii, **param)
