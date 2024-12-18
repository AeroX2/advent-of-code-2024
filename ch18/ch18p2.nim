
import std/os
import std/sets
import std/tables
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
  path: seq[Coord]

proc `<` (a: HeapQueueItem, b: HeapQueueItem): bool = a.s < b.s

let DIRECTIONS: seq[Coord] = @[(0, 1), (0, -1), (-1, 0), (1, 0)]

let fileContent = readFile(paramStr(1));
let grid = splitLines(fileContent)

proc printGrid(
  grid: seq[string],
  walls: Hashset[Coord],
  startPoint: Coord,
  endPoint: Coord,
  finalCoords: HashSet[Coord] = initHashSet[Coord]()
) =
  for y in 0..<grid.len:
    for x in 0..<grid[0].len:
      if (startPoint == (x,y)):
        stdout.write 'S'
      elif (endPoint == (x,y)):
        stdout.write 'E'
      elif (walls.contains((x,y))):
        stdout.write '#'
      elif (finalCoords.contains((x,y))):
        stdout.write 'W'
      else:
        stdout.write '.'
    echo ""
  echo ""

proc pathFind(
  walls: HashSet[Coord],
  startPoint: Coord,
  endPoint: Coord,
): HashSet[Coord] =
  var seen = initHashSet[HashSet[Coord]]()
  var scoreAtCoord = initTable[Coord, int]()
  var hq = initHeapQueue[HeapQueueItem]()

  hq.push((startPoint, (0,0), 0, @[startPoint]))

  var finalScore = 1000000
  var finalPath = initHashSet[Coord]()
  while (hq.len > 0):
    let (p,d,s,pa) = hq.pop()
    if (scoreAtCoord.contains(p)):
      if (s - 1000 > scoreAtCoord[p]):
        continue

    let pas = toHashSet(pa)
    if (seen.contains(pas)):
      continue
    seen.incl(pas)
    discard scoreAtCoord.hasKeyOrPut(p, s)
    scoreAtCoord[p] = min(scoreAtCoord[p], s)

    if (p == endPoint):
      if (s < finalScore):
        finalScore = s
        finalPath = pas
      if (s == finalScore):
        finalPath = finalPath + pas
      continue

    for direction in DIRECTIONS:
      let np = p + direction

      let score = s + 1 + (if (d == (0,0) or d == direction): 0 else: 1000)
      if (walls.contains(np)):
        continue

      var npa = pa
      npa.add(np)

      hq.push((np, direction, score, npa))

  return finalPath



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

let finalCoords = pathFind(walls, startPoint, endPoint)

# var finalCoords = initHashSet[Coord]()
# for path in paths:
#   finalCoords = finalCoords + toHashSet(toSeq(path))
echo finalCoords.len

printGrid(grid, walls, startPoint, endPoint, finalCoords)