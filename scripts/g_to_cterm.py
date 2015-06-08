import sys
from grapefruit import Color
from xterm256 import rgb_to_xterm

new_vim_color = []

def html2xterm256(color):
    r, g, b = Color.HtmlToRgb(color)
    r = int(r*255)
    g = int(g*255)
    b = int(b*255)
    return rgb_to_xterm(r, g, b)

color = raw_input()
while color != "exit":
    print html2xterm256(color)
    color = raw_input()
