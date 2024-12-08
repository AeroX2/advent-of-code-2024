
import std/os
import std/strutils
import std/sequtils
import std/tables
import std/sets

type Coord = tuple
    x: int
    y: int

proc `+` (a: Coord, b: Coord): Coord = (x: a.x + b.x, y: a.y + b.y)
proc `+=` (a: var Coord, b: Coord) = a = (x: a.x + b.x, y: a.y + b.y)
proc `-` (a: Coord, b: Coord): Coord = (x: a.x - b.x, y: a.y - b.y)
proc `-=` (a: var Coord, b: Coord) = a = (x: a.x - b.x, y: a.y - b.y)

proc inBounds(a: Coord, data: seq[string]): bool = 
    a.x >= 0 and a.x <= data[0].len-1 and
    a.y >= 0 and a.y <= data.len-1

let fileContent = readFile(paramStr(1));
var data = splitLines(fileContent)

var towersMap = initTable[char, seq[Coord]]()
for y, line in data:
    for x,c in line:
        if c == '.':
            continue
        discard towersMap.hasKeyOrPut(c, @[])
        towersMap[c].add((x,y))

var antinodesMap = initTable[char, seq[Coord]]()
for tower, positions in towersMap:
    if (positions.len <= 1):
        continue

    var antinodes = initHashSet[Coord]()
    for i, p1 in positions:
        for p2 in positions[i+1..<positions.len]:
            antinodes.incl(p1)
            antinodes.incl(p2)

            var d = (x: (p1.x - p2.x), y: (p1.y - p2.y))
            let od = d

            while (inBounds(p1 + d, data)):
                antinodes.incl(p1 + d)
                d += od

            d = od
            while (inBounds(p2 - d, data)):
                antinodes.incl(p2 - d)
                d += od
    antinodesMap[tower] = toSeq(antinodes)

var sum = 0
for tower, antinodesSeq in antinodesMap:
    for antinode in antinodesSeq:
        data[antinode.y][antinode.x] = '#'

for line in data:
    sum += line.count('#')
    echo line
echo sum