
#from codecs import decode

#def hex_str_to_bin_list(hex_str):
#    h = hex_str.replace('_', '')
#    codecs.decode(h, 'hex')

def hex_str_to_bin_list(hex_str):
    r = []
    for dig in hex_str:
        if dig == '_':
            continue
        d = int(dig, 16) 
        for i in range(0, 4):
            b = (d & (1 << (3-i))) >> (3-i)
            r.append(b)

    return r
