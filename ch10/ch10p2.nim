import std/os
import std/strutils
import std/sequtils
import std/heapqueue

let fileContent = readFile(paramStr(1));
let fileData = splitLines(fileContent)
let data = fileData.mapIt(it.mapIt(int(it) - int('0')))

type Coord = tuple
    x: int
    y: int
    maxDistanceFromHigh: int

proc `+` (a: Coord, b: Coord): Coord = (a.x + b.x, a.y + b.y, max(a.maxDistanceFromHigh, b.maxDistanceFromHigh))
proc `-` (a: Coord, b: Coord): Coord = (a.x - b.x, a.y - b.y, max(a.maxDistanceFromHigh, b.maxDistanceFromHigh))
proc `<` (a: Coord, b: Coord): bool = a.maxDistanceFromHigh < b.maxDistanceFromHigh

type Path = tuple
    path: seq[Coord]

proc `<` (a: Path, b: Path): bool = a.path[^1] < b.path[^1]

let DIRECTIONS: seq[Coord] = @[(0, 1, -1), (0, -1, -1), (-1, 0, -1), (1, 0, -1)]

proc maxDist(start: Coord, ends: seq[Coord]): int =
    var maxD = -1
    for endC in ends:
        maxD = max(maxD, abs(start.x - endC.x) + abs(start.y - endC.y))
    return maxD

proc pathfind(data: seq[seq[int]], start: Coord): int =
    var score = 0

    var queue = initHeapQueue[Path]()
    queue.push((path: @[start]))
    while queue.len > 0:
        let path = queue.pop()
        let pos = path.path[^1]
        let val = data[pos.y][pos.x]

        if (val == 9):
            score += 1
            continue

        for d in DIRECTIONS:
            let newPos = pos + d
            if not (newPos.x >= 0 and newPos.x <= data[0].len-1 and
                newPos.y >= 0 and newPos.y <= data.len-1):
                continue
            
            let newVal = data[newPos.y][newPos.x]
            if (newVal - val != 1):
                continue
                
            queue.push((path: concat(path.path, @[newPos])))
    
    return score

var starts: seq[Coord] = @[]
var ends: seq[Coord] = @[]
for y,line in data:
    for x,c in line:
        if (c == 0):
            starts.add((x,y,-1))
        elif (c == 9):
            ends.add((x,y,-1))

var score = 0
for start in starts:
    score += pathfind(data, (start.x,start.y, maxDist(start, ends)))
echo score