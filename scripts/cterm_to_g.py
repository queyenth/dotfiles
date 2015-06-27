import sys
from grapefruit import Color
from xterm256 import xterm_to_rgb

def xterm2html(color):
    r, g, b = xterm_to_rgb(int(color))
    return Color.RgbToHtml(r, g, b)

color = raw_input()
while color != "exit":
    print xterm2html(color)
    color = raw_input()
