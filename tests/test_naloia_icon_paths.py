import hashlib
import re
import unittest
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets" / "naloia"
NUMBER = r"-?(?:\d+(?:\.\d+)?|\.\d+)"
PATH_TOKENS = re.compile(r"[A-Z]|" + NUMBER)
ARG_COUNTS = {"M": 2, "L": 2, "H": 1, "C": 6, "Q": 4, "Z": 0}
CG_COMMANDS = {
    "MoveToPoint": "M",
    "AddLineToPoint": "L",
    "AddCurveToPoint": "C",
    "AddQuadCurveToPoint": "Q",
    "CloseSubpath": "Z",
    "AddEllipseInRect": "ellipse",
}
ORIGINALS = {
    "favorite": "9435a72946fe7728aca971d6a438e5250b07b2804b0ad7b79a37c2d737c9991f",
    "comment": "ea0a46d415d703fe7324c4578662f7fb53b317c64707df7435195f62f26827ad",
    "like": "b36b23ff7d8893d35df65683d6c2fd8a3084b4cb84ae630670ed13f8880572ea",
    "share": "d443cd75a6dfec94ed52e7407e4f564d5652e447599c6348990446b24e48fb49",
}


def svg_subpaths(path):
    subpaths = []
    tokens = iter(PATH_TOKENS.findall(path.attrib["d"]))
    for command in tokens:
        points = tuple(float(next(tokens)) for _ in range(ARG_COUNTS[command]))
        if command == "M":
            subpaths.append([])
        if command == "H":
            command, points = "L", (points[0], subpaths[-1][-1][1][-1])
        subpaths[-1].append((command, points))
    return subpaths


class NaloiaIconPathsTest(unittest.TestCase):
    def test_archived_vectors_match_all_native_subpaths(self):
        native = (ROOT / "native" / "FanqieXNaloiaPaths.inc").read_text(encoding="utf-8")
        paths = {}
        for name, body in re.findall(r"case FQXNaloia(\w+):\s*(.*?)\bbreak;", native, re.S):
            paths[name] = [
                (CG_COMMANDS[command], tuple(map(float, re.findall(NUMBER, arguments))))
                for command, arguments in re.findall(r"CGPath(\w+)\(path([^;]*)\);", body)
            ]

        for name, parts in {
            "favorite": ("FavoriteMain", "FavoriteLeft"),
            "comment": ("CommentLeft", "CommentRight"),
            "like": ("LikeHeart", "LikeECG"),
            "share": ("ShareAirfoil",),
        }.items():
            with self.subTest(icon=name):
                source = (ASSETS / f"{name}.svg").read_bytes()
                self.assertEqual(hashlib.sha256(source).hexdigest(), ORIGINALS[name])
                svg = ET.fromstring(source)
                self.assertEqual((svg.attrib["width"], svg.attrib["height"]), ("108", "108"))
                self.assertEqual(svg.attrib["viewBox"], "0 0 88 88")
                group, = svg
                self.assertEqual(group.attrib["fill"], "#FFFFFF")
                scale = "1.15" if name == "favorite" else "1"
                self.assertEqual(group.attrib["transform"], f"translate(44 44) scale({scale}) translate(-32 -32)")
                self.assertEqual(group[0].attrib["fill-rule"], "evenodd")
                drawings = svg_subpaths(group[0])
                if name == "share":
                    drawings = [drawings[0] + drawings[1]]
                self.assertEqual(len(drawings), len(parts))
                for part, drawing in zip(parts, drawings):
                    self.assertEqual(paths[part], drawing)
                if name == "favorite":
                    cx, cy, radius = (float(group[1].attrib[key]) for key in ("cx", "cy", "r"))
                    self.assertEqual(paths["FavoriteDot"], [("ellipse", (cx - radius, cy - radius, 2 * radius, 2 * radius))])


if __name__ == "__main__":
    unittest.main()
