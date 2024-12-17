import std/os
import std/sets
import std/strutils
import std/sequtils
import std/heapqueue

type Coord = tuple
  x: int
  y: int

proc `+` (a: Coord, b: Coord): Coord = (a.x + b.x, a.y + b.y)
proc `-` (a: Coord, b: Coord): Coord = (a.x - b.x, a.y - b.y)

type HeapQueueItem = tuple
  p: Coord
  d: Coord
  s: int

proc `<` (a: HeapQueueItem, b: HeapQueueItem): bool = a.s < b.s

let DIRECTIONS: seq[Coord] = @[(0, 1), (0, -1), (-1, 0), (1, 0)]

let fileContent = readFile(paramStr(1));
let grid = splitLines(fileContent)

proc printGrid(
  grid: seq[string],
  walls: Hashset[Coord],
  startPoint: Coord,
  endPoint: Coord,
) =
  for y in 0..<grid.len:
    for x in 0..<grid[0].len:
      if (startPoint == (x,y)):
        stdout.write 'S'
      elif (endPoint == (x,y)):
        stdout.write 'E'
      elif (walls.contains((x,y))):
        stdout.write '#'
      else:
        stdout.write '.'
    echo ""
  echo ""

proc pathFind(
  walls: HashSet[Coord],
  startPoint: Coord,
  endPoint: Coord,
): int =
  var seen = initHashSet[(Coord, Coord)]()
  var hq = initHeapQueue[HeapQueueItem]()
  hq.push((startPoint, (0,0), 0))

  var finalScore = 100000000
  while (hq.len > 0):
    let (p,d,s) = hq.pop()

    if (seen.contains((p,d))):
      continue
    seen.incl((p,d))

    for direction in DIRECTIONS:
      let np = p + direction
      let score = s + 1 + (if (direction == d): 0 else: 1000)

      if (np == endPoint):
        finalScore = min(finalScore, if (d == direction): score - 1000 else: score)
        continue

      if (walls.contains(np)):
        continue

      hq.push((np, direction, score))
  return finalScore



var startPoint: Coord;
var endPoint: Coord;
var walls = initHashSet[Coord]()

for y,line in grid:
  for x,c in line:
    case (c):
      of '#':
        walls.incl((x,y))
      of 'S':
        startPoint = (x,y)
      of 'E':
        endPoint = (x,y)
      else:
        discard

printGrid(grid, walls, startPoint, endPoint)

echo pathFind(walls, startPoint, endPoint)