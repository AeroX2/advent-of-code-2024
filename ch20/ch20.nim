import std/os
import std/sets
import std/strutils
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

let DIRECTIONS: seq[Coord] = @[(0, 1), (0, -1), (-1, 0), (1, 0)]

let fileContent = readFile(paramStr(1));
let grid = splitLines(fileContent)

proc printGrid(
  grid: seq[string],
  walls: Hashset[Coord],
  path: seq[Coord] = @[],
) =
  for y in 0..<grid[0].len:
    for x in 0..<grid.len:
      if (walls.contains((x,y))):
        stdout.write '#'
      elif (path.contains((x,y))):
        stdout.write 'O'
      else:
        stdout.write '.'
    echo ""
  echo ""

proc pathFind(
  grid: seq[string],
  walls: HashSet[Coord],
  startPoint: Coord,
  endPoint: Coord,
): seq[seq[Coord]] =
  var finalPaths: seq[seq[Coord]] = @[]
  var seen = initHashSet[(Coord)]()
  var hq = initHeapQueue[HeapQueueItem]()
  hq.push((startPoint, 0, @[startPoint]))

  while (hq.len > 0):
    let (p,s,pa) = hq.pop()

    if (p == endPoint):
      return @[pa]

    if (seen.contains((p))):
      continue
    seen.incl((p))

    for direction in DIRECTIONS:
      let np = p + direction
    
      if (np.x < 0 or np.x > grid[0].len-1 or
          np.y < 0 or np.y > grid.len-1):
        continue

      if (walls.contains(np)):
        continue

      var npa = pa
      npa.add(np)

      hq.push((np, s+1, npa))

  return finalPaths

var startPoint: Coord;
var endPoint: Coord;
var walls = initHashSet[Coord]()
for y,line in grid:
  for x,c in line:
    if (c == '#'):
      walls.incl((x,y))
    elif (c == 'S'):
      startPoint = (x,y)
    elif (c == 'E'):
      endPoint = (x,y)

let shortestPaths = pathFind(grid, walls, startPoint, endPoint)
let path = shortestPaths[0]

var sum = 0
for c in path:
  for direction in DIRECTIONS:
    let nc1 = c + direction
    let nc2 = nc1 + direction

    if (nc1.x < 0 or nc1.x > grid[0].len-1 or
        nc1.y < 0 or nc1.y > grid.len-1):
      continue
    if (nc2.x < 0 or nc2.x > grid[0].len-1 or
        nc2.y < 0 or nc2.y > grid.len-1):
      continue

    if (not (walls.contains(nc1) and not walls.contains(nc2))):
      continue

    if (path.find(nc2) - path.find(c) > 100):
      sum += 1
echo sum
