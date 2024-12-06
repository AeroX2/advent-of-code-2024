import std/os
import std/sets
import std/strutils
import std/enumerate

type Coord = tuple
    x: int
    y: int

type Direction = enum
    UP, RIGHT, DOWN, LEFT

let fileContent = readFile(paramStr(1));
let data = splitLines(fileContent)

var guardPos: Coord;
var guardDirection: Direction = Direction.UP

for y, line in enumerate(data):
    let x = find(line, "^")
    if (x != -1):
        guardPos = (x, y)
        break

proc moveForward(pos: Coord, dir: Direction): Coord =
  case dir
  of Direction.UP: (x: pos.x, y: pos.y - 1)
  of Direction.DOWN: (x: pos.x, y: pos.y + 1)
  of Direction.LEFT: (x: pos.x - 1, y: pos.y)
  of Direction.RIGHT: (x: pos.x + 1, y: pos.y)

proc turnRight(dir: Direction): Direction =
  Direction((dir.int + 1) mod 4)

var seen = initHashSet[Coord]()
while (guardPos.x > 0 and
      guardPos.x < data[0].len-1 and
      guardPos.y > 0 and
      guardPos.y < data.len-1):
    seen.incl(guardPos)
    
    let oldGuardPos = guardPos;
    var newGuardPos = moveForward(guardPos, guardDirection)
    
    if (data[newGuardPos.y][newGuardPos.x] == '#'):
        newGuardPos = oldGuardPos;
        guardDirection = turnRight(guardDirection)
    
    guardPos = newGuardPos

var newData = data
for c in seen:
    newData[c.y][c.x] = 'X'

for line in newData:
    echo line

echo seen.len+1



