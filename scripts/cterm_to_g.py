import sys
from grapefruit import Color
from x256 import x256

def xterm2html(color):
    r, g, b = x256.to_rgb(int(color))
    return Color.RgbToHtml(r / 255, g / 255, b / 255)

color = input()
while color != "exit":
    print(xterm2html(color))
    color = input()
