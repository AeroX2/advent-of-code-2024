import std/os
import std/tables
import std/strutils
import std/enumerate

type Coord = tuple
    x: int
    y: int

type Direction = enum
    UP, DOWN, LEFT, RIGHT

let fileContent = readFile(paramStr(1));
let data = splitLines(fileContent)

var guardPos: Coord;
var guardDirection: Direction = Direction.UP

for y, line in enumerate(data):
    let x = find(line, "^")
    if (x != -1):
        guardPos = (x, y)
        break

var seen = initTable[Coord, bool]()
while (guardPos.x > 0 and
      guardPos.x < data[0].len-1 and
      guardPos.y > 0 and
      guardPos.y < data.len-1):
    seen[guardPos] = true
    
    let oldGuardPos = guardPos;
    var newGuardPos: Coord;
    if (guardDirection == Direction.UP):
        newGuardPos = (x: guardPos.x, y: guardPos.y-1)
    elif (guardDirection == Direction.DOWN):
        newGuardPos = (x: guardPos.x, y: guardPos.y+1)
    elif (guardDirection == Direction.LEFT):
        newGuardPos = (x: guardPos.x-1, y: guardPos.y)
    elif (guardDirection == Direction.RIGHT):
        newGuardPos = (x: guardPos.x+1, y: guardPos.y)
    
    if (data[newGuardPos.y][newGuardPos.x] == '#'):
        newGuardPos = oldGuardPos;
        if (guardDirection == Direction.UP):
            guardDirection = Direction.RIGHT
        elif (guardDirection == Direction.DOWN):
            guardDirection = Direction.LEFT
        elif (guardDirection == Direction.LEFT):
            guardDirection = Direction.UP
        elif (guardDirection == Direction.RIGHT):
            guardDirection = Direction.DOWN
    
    guardPos = newGuardPos

var newData = data
for c in seen.keys:
    newData[c.y][c.x] = 'X'

for line in newData:
    echo line

echo seen.len+1



