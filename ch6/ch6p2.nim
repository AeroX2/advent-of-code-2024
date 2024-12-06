import std/os
import std/tables
import std/strutils
import std/enumerate

type Coord = tuple
    x: int
    y: int

type Direction = enum
    UP, RIGHT, DOWN, LEFT

let fileContent = readFile(paramStr(1));
let data = splitLines(fileContent)

proc moveForward(pos: Coord, dir: Direction): Coord =
  case dir
  of Direction.UP: (x: pos.x, y: pos.y - 1)
  of Direction.DOWN: (x: pos.x, y: pos.y + 1)
  of Direction.LEFT: (x: pos.x - 1, y: pos.y)
  of Direction.RIGHT: (x: pos.x + 1, y: pos.y)

proc turnRight(dir: Direction): Direction =
  Direction((dir.int + 1) mod 4)

proc simulate(data: seq[string], initAmount = -1): (Table[Coord, Direction], bool) =
    var seen = initTable[Coord, Direction](data.len * data[0].len)
    # var test = initTable[int, Direction](data.len * data[0].len)

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

        if (initAmount != -1):
            discard
            # Seems like Nim tables is slow? The code is faster without the early exit?
            
            # if (test.hasKey(guardPos.y*1337+guardPos.x)):
            #     if (test[guardPos.y*1337+guardPos.x] == guardDirection):
                    
            #         return (seen, true)
            # test[guardPos.y*1337+guardPos.x] = guardDirection
        else:
            seen[guardPos] = guardDirection
        
        let oldGuardPos = guardPos;
        var newGuardPos = moveForward(guardPos, guardDirection)

        if not (newGuardPos.x >= 0 and
            newGuardPos.x <= data[0].len-1 and
            newGuardPos.y >= 0 and
            newGuardPos.y <= data.len-1):
            break

        if (data[newGuardPos.y][newGuardPos.x] == '#'):
            newGuardPos = oldGuardPos;
            guardDirection = turnRight(guardDirection)

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