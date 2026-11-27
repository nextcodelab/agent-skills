"""Draw transparent, original illustrations for finance and market structure."""

from pathlib import Path
import math
import json

from PIL import Image, ImageDraw


OUTPUT = Path(__file__).resolve().parent
SIDE = 256
SUPERSAMPLE = 4
NAVY = "#102639"
PAPER = "#FFF5DE"
ICE = "#92DBFF"
MINT = "#9AF0CE"
GOLD = "#FFD483"
CORAL = "#FFB098"


class Sticker:
    def __init__(self):
        self.canvas = Image.new("RGBA", (SIDE * SUPERSAMPLE, SIDE * SUPERSAMPLE))
        self.draw = ImageDraw.Draw(self.canvas)

    @staticmethod
    def coord(number):
        return round(number * SUPERSAMPLE)

    def point(self, point):
        return tuple(self.coord(number) for number in point)

    def line(self, points, color=PAPER, width=7):
        """Two strokes give the graphic contrast over bright or dark footage."""
        scaled = [self.point(p) for p in points]
        for stroke, thickness in ((NAVY, width + 8), (color, width)):
            self.draw.line(scaled, fill=stroke, width=self.coord(thickness), joint="curve")
            r = self.coord(thickness) / 2
            for x, y in [scaled[0], scaled[-1]]:
                self.draw.ellipse((x-r, y-r, x+r, y+r), fill=stroke)

    def polygon(self, points, fill, color=PAPER, width=6):
        self.draw.polygon([self.point(p) for p in points], fill=fill)
        self.line([*points, points[0]], color, width)

    def ellipse(self, bounds, fill=None, color=PAPER, width=6):
        x1, y1, x2, y2 = bounds
        self.draw.ellipse(self.point((x1-4, y1-4, x2+4, y2+4)), fill=fill, outline=NAVY, width=self.coord(width+8))
        self.draw.ellipse(self.point(bounds), fill=fill, outline=color, width=self.coord(width))

    def roundrect(self, bounds, radius, fill, color=PAPER, width=6):
        x1, y1, x2, y2 = bounds
        self.draw.rounded_rectangle(self.point((x1-4, y1-4, x2+4, y2+4)), radius=self.coord(radius+4), fill=NAVY)
        self.draw.rounded_rectangle(self.point(bounds), radius=self.coord(radius), fill=fill, outline=color, width=self.coord(width))

    def arc(self, bounds, start, end, color=PAPER, width=7):
        x1, y1, x2, y2 = bounds
        return self.line([
            ((x1+x2)/2 + (x2-x1)/2*math.cos(math.radians(deg)), (y1+y2)/2 + (y2-y1)/2*math.sin(math.radians(deg)))
            for deg in [start+(end-start)*i/36 for i in range(37)]
        ], color, width)

    def arrow(self, points, tip, color=PAPER):
        self.line(points, color)
        self.line(tip, color)

    def spark(self, x, y, color=GOLD, size=10):
        self.line([(x-size, y), (x+size, y)], color, 4)
        self.line([(x, y-size), (x, y+size)], color, 4)

    def save(self, name):
        self.canvas.resize((SIDE, SIDE), Image.Resampling.LANCZOS).save(OUTPUT / f"{name}.png")


def institution(s):
    s.polygon([(42, 92), (128, 46), (214, 92)], "#35566A", GOLD)
    s.ellipse((119, 66, 137, 84), NAVY, PAPER, 4)
    for x in [67, 106, 150, 189]:
        s.line([(x, 112), (x, 174)], PAPER, 9)
    s.line([(52, 180), (204, 180)], PAPER, 8)
    s.line([(40, 202), (216, 202)], GOLD, 9)
    s.spark(212, 48, GOLD, 9)


def calendar(s):
    s.roundrect((49, 53, 184, 185), 19, "#2B506A", PAPER)
    s.line([(56, 88), (177, 88)], ICE, 6)
    for x in [78, 152]:
        s.line([(x, 40), (x, 70)], PAPER, 8)
    for x, y in [(78, 115), (111, 115), (145, 115), (78, 145), (109, 145)]:
        s.roundrect((x-6,y-6,x+6,y+6), 4, ICE, ICE, 2)
    s.ellipse((129, 129, 215, 215), "#204658", GOLD, 6)
    s.line([(172, 151), (172, 174), (188, 184)], PAPER, 6)


def token(s):
    for x, y, accent in [(67, 54, MINT), (36, 119, ICE), (119, 119, GOLD)]:
        s.polygon([(x, y), (x+44, y-21), (x+88, y), (x+44, y+22)], "#345769", accent)
        s.polygon([(x, y), (x+44, y+22), (x+44, y+63), (x, y+40)], "#274459", accent, 5)
        s.polygon([(x+44, y+22), (x+88, y), (x+88, y+41), (x+44, y+63)], "#426172", accent, 5)
    s.spark(197, 69, MINT, 9)


def rail(s):
    for offset in (0, 42):
        s.line([(52+offset, 210), (52+offset, 115), (116+offset, 48), (198+offset/3, 48)], ICE if offset else PAPER, 9)
    for x, y in [(53,179), (53,144), (63,105), (89,77)]:
        s.line([(x-13,y), (x+53,y)], GOLD, 5)
    s.arrow([(117, 208), (117, 134), (181, 73), (217, 73)], [(202, 62), (217, 73), (203, 85)], MINT)


def globe(s):
    s.ellipse((43, 44, 213, 214), "#2A526C", ICE, 7)
    s.arc((88, 47, 168, 211), 0, 360, PAPER, 5)
    s.line([(48, 129), (209, 129)], PAPER, 5)
    s.arc((50, 69, 206, 109), 18, 162, MINT, 5)
    s.arc((50, 149, 206, 189), 198, 342, MINT, 5)
    for x, y, color in [(92, 122, GOLD), (166, 89, MINT), (160, 168, CORAL)]:
        s.ellipse((x-8, y-8, x+8, y+8), color, PAPER, 2)


def exchange(s):
    s.arrow([(52, 95), (202, 95)], [(177, 67), (204, 95), (177, 123)], MINT)
    s.arrow([(204, 160), (54, 160)], [(79, 131), (52, 160), (79, 188)], PAPER)
    s.spark(70, 58, GOLD, 8)
    s.spark(186, 198, ICE, 8)


def people(s):
    s.ellipse((42, 78, 97, 133), "#325D75", ICE, 5)
    s.ellipse((160, 78, 215, 133), "#325D75", ICE, 5)
    s.arc((25, 137, 108, 212), 189, 292, ICE, 7)
    s.arc((149, 137, 232, 212), 245, 350, ICE, 7)
    s.ellipse((95, 54, 161, 120), "#3C6664", MINT, 6)
    s.arc((69, 137, 187, 225), 187, 353, PAPER, 8)
    s.line([(70, 187), (187, 187)], PAPER, 8)


def liquidity(s):
    for x, y, fill, edge in [(80, 135, "#3D706E", MINT), (160, 127, "#4E5D64", GOLD), (121, 76, "#335C74", ICE)]:
        s.ellipse((x-37, y-29, x+37, y+29), fill, edge, 6)
        s.arc((x-21, y-13, x+21, y+13), 22, 193, edge, 4)
    s.arrow([(49, 179), (91, 202), (156, 203), (208, 171)], [(188, 170), (208, 171), (204, 192)], PAPER)


def rules(s):
    s.polygon([(127, 45), (195, 67), (190, 138), (167, 173), (127, 205), (87, 173), (64, 138), (59, 67)],
              "#35646A", MINT, 7)
    s.line([(95, 128), (118, 151), (161, 105)], PAPER, 9)
    s.spark(205, 51, GOLD, 9)


def clock(s):
    s.ellipse((44, 44, 212, 212), "#2A4D66", ICE, 7)
    for x, y, dx, dy in [(128,56,0,14),(128,199,0,-14),(56,128,14,0),(199,128,-14,0)]:
        s.line([(x,y),(x+dx,y+dy)], GOLD, 4)
    s.line([(128, 78), (128, 129), (165, 150)], PAPER, 9)
    s.spark(201, 53, MINT, 8)


def structure(s):
    for a,b in [((65,90),(126,128)),((189,77),(126,128)),((126,128),(82,193)),((126,128),(186,186))]:
        s.line([a,b], ICE, 7)
    for x,y,c in [(65,90,GOLD),(189,77,ICE),(126,128,MINT),(82,193,ICE),(186,186,CORAL)]:
        s.ellipse((x-17,y-17,x+17,y+17), "#2C4E63", c, 6)


def chart(s):
    s.line([(49, 55), (49, 195), (211, 195)], PAPER, 7)
    values = [(83,89,152,115,140,MINT),(120,112,175,132,159,ICE),
              (154,63,133,82,108,GOLD),(190,95,159,107,136,CORAL)]
    for x, a, b, top, bottom, color in values:
        s.line([(x, a), (x, b)], color, 5)
        s.roundrect((x-9, top, x+9, bottom), 3, color, color, 3)


PACK = {
    "institution": (institution, ["wall street", "bank", "institution", "traditional finance"]),
    "calendar": (calendar, ["market hours", "weekend", "round the clock", "24/7"]),
    "token": (token, ["tokenization", "blockchain", "token", "asset"]),
    "rail": (rail, ["rails", "technology", "settlement", "infrastructure"]),
    "globe": (globe, ["global", "international", "cross-border", "border"]),
    "exchange": (exchange, ["exchange", "trading", "transfer", "two-sided market"]),
    "people": (people, ["investors", "people", "clients", "access"]),
    "liquidity": (liquidity, ["liquidity", "capital flows", "funding", "money"]),
    "rules": (rules, ["regulation", "guardrails", "trust", "oversight"]),
    "clock": (clock, ["speed", "real time", "waiting", "settlement"]),
    "structure": (structure, ["market structure", "network", "intermediaries", "systems"]),
    "chart": (chart, ["markets", "investing", "trading", "volatility"]),
}


def main():
    files = []
    for name, (render, tags) in PACK.items():
        sticker = Sticker()
        render(sticker)
        sticker.save(name)
        alpha = sticker.canvas.getchannel("A")
        assert alpha.getpixel((0, 0)) == 0
        assert alpha.getbbox() is not None
        files.append({"file": f"{name}.png", "tags": tags, "background": "transparent"})
    (OUTPUT / "sticker-pack.json").write_text(
        json.dumps({
            "id": "onchain-transparent-finance-stickers",
            "origin": "Original procedural illustrations created locally for the project",
            "external_assets": [],
            "editable_source": "draw_stickers.py",
            "intended_use": "Contextual illustrations. They do not represent real brands, price series, or market data.",
            "files": files,
        }, indent=2) + "\n", 
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
