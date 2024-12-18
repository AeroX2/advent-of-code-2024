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
  s: int
  path: seq[Coord]

proc `<` (a: HeapQueueItem, b: HeapQueueItem): bool = a.s < b.s

let WIDTH = 70
let HEIGHT = 70
let DIRECTIONS: seq[Coord] = @[(0, 1), (0, -1), (-1, 0), (1, 0)]

let fileContent = readFile(paramStr(1));
let lines = splitLines(fileContent)

proc printGrid(
  walls: Hashset[Coord],
  path: seq[Coord] = @[],
) =
  for y in 0..WIDTH:
    for x in 0..HEIGHT:
      if (walls.contains((x,y))):
        stdout.write '#'
      elif (path.contains((x,y))):
        stdout.write 'O'
      else:
        stdout.write '.'
    echo ""
  echo ""

proc pathFind(
  walls: HashSet[Coord],
  startPoint: Coord,
  endPoint: Coord,
): seq[Coord] =
  var seen = initHashSet[Coord]()
  var hq = initHeapQueue[HeapQueueItem]()
  hq.push((startPoint, 0, @[startPoint]))

  while (hq.len > 0):
    let (p,s,pa) = hq.pop()

    if (seen.contains(p)):
      continue
    seen.incl(p)

    for direction in DIRECTIONS:
      let np = p + direction

      if (np == endPoint):
        return pa
    
      if (np.x < 0 or np.x > WIDTH or
          np.y < 0 or np.y > HEIGHT):
        continue
      if (walls.contains(np)):
        continue

      var npa = pa
      npa.add(np)

      hq.push((np, s+1, npa))

var previousPath: seq[Coord] = @[]
var walls = initHashSet[Coord]()
for line in lines:
  let b = line.split(",")
  let x = parseInt(b[0])
  let y = parseInt(b[1])
  walls.incl((x,y))

  if (previousPath.len == 0 or previousPath.contains((x,y))):
    let path = pathFind(walls, (0,0), (WIDTH,HEIGHT))
    if (path.len <= 0):
      echo line
      break
    previousPath = path