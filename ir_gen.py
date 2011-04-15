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

ncpc_ = {
    'BPSK': 1,
    'QPSK': 2,
    '16-QAM': 4,
    '64-QAM': 6
}

ncbps_ = {
        'BPSK': [ 192, 96, 48, 24, 12 ],
        'QPSK': [384, 192, 96, 48, 24 ],
        '16-QAM': [768, 384, 192, 96, 48],
        '64-QAM': [1152, 576, 288, 144, 72]
}

subchan_ct = {
        16: 0,
        8:  1,
        4:  2,
        2:  3,
        1:  4
}

param = {
    'out_var' : 'out_blk',
    'in_var'  : 'inr',
    'ncpc'    : ncpc_['QPSK'],
    'ncbps'   : ncbps_['QPSK'][subchan_ct[8]],
}

ncpc = param['ncpc']
ncbps = param['ncbps']

s = ceil(ncpc / 2)

m = []

for k in range(0, ncbps):
    m.append((ncbps / 12) * (k % 12) + floor(k / 12));

j = []

for k in range(0, ncbps):
    j.append(s * floor(m[k] / s) + ((m[k] + ncbps - \
        floor(12 * m[k] / ncbps) ) % s))

for k in range(0, ncbps):
    x = "{out_var}[{k}] <= {in_var}[{in_index}];"
    print x.format(k = int(k), in_index = int(j[int(k)]), **param)
    


