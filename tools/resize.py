from PIL import Image

import sys

def resize(src, tgt=None, scale=1, width=None, height=None):
    img = Image.open(src)
    w, h = img.size

    if (width is not None) and (height is not None):
        rh = width * h
        rw = height * w

        if rh < rw:
            height = rh // w
        if rw < rh:
            width = rw // h
    else:
        width = math.floor(w * scale)
        height = math.floor(h * scale)
    if tgt is None:
        fn, ext = src.split('.')
        tgt = '_'.join([fn, str(width), str(height)]) + '.' + ext
    new_img = img.resize((width, height), Image.ANTIALIAS)
    new_img.save(tgt)

if "__main__" == __name__:
    if 1 < len(sys.argv):
        resize(sys.argv[1], width=240, height=240)
