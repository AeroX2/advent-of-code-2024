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


proc simulate(data: seq[string], initAmount = -1): (Table[Coord, bool], bool) =
    var seen = initTable[Coord, bool]()

    var guardDirection: Direction = Direction.UP
    var guardPos: Coord;
    for y, line in enumerate(data):
        let x = find(line, "^")
        if (x != -1):
            guardPos = (x, y)
            break

    var amount = initAmount;
    while amount != 0:
        amount -= 1
        # if (seen.hasKey(guardPos)):
        #     return (seen, true)
        if (initAmount == -1):
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

        if not (newGuardPos.x >= 0 and
            newGuardPos.x <= data[0].len-1 and
            newGuardPos.y >= 0 and
            newGuardPos.y <= data.len-1):
            break

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

    return (seen, amount == 0)


var (seen,_) = simulate(data)

var obstructions: seq[Coord] = @[]
for c in seen.keys:
    var newGrid = data
    newGrid[c.y][c.x] = '#'

    let (_,earlyExit) = simulate(newGrid, 10000)
    if (earlyExit):
        obstructions.add(c)

echo obstructions.len