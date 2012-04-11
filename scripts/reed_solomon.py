from bitstring import BitArray

# Reed-Solomon for WIMAX (pg 622).


N = 255 # overall bytes after encoding
K = 239
T = 8
#               876543210
F = BitArray('0b100011101') # Field Generator Polynomial, p(x) = x^8 + x^4 + x^3 + x^2 + 1.

# When the block size < 239 (K), prefix with zero bytes, encode, and discard.


def gf8_mult(poly, a, b):
	"""Galios field multiplier on GF(2^8)"""

