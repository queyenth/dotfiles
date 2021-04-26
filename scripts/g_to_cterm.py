import sys
from grapefruit import Color
from x256 import x256

def html2xterm256(color):
    r, g, b = Color.HtmlToRgb(color)
    r = int(r*255)
    g = int(g*255)
    b = int(b*255)
    return x256.from_rgb(r, g, b)

color = input()
while color != "exit":
    print(html2xterm256(color))
    color = input()
