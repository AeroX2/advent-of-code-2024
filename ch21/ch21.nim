import std/os
import std/sets
import std/tables
import std/strutils
import std/sequtils
import std/heapqueue
import std/algorithm

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

var numpad = initTable[char, Coord]()
numpad['7'] = (0,0)
numpad['8'] = (1,0)
numpad['9'] = (2,0)
numpad['4'] = (0,1)
numpad['5'] = (1,1)
numpad['6'] = (2,1)
numpad['1'] = (0,2)
numpad['2'] = (1,2)
numpad['3'] = (2,2)
numpad['0'] = (1,3)
numpad['A'] = (2,3)

var directionalPad = initTable[char, Coord]()
directionalPad['^'] = (1,0)
directionalPad['A'] = (2,0)
directionalPad['<'] = (0,1)
directionalPad['v'] = (1,1)
directionalPad['>'] = (2,1)

let fileContent = readFile(paramStr(1));
let lines = splitLines(fileContent)

proc pathFind(
  grid: Table[char, Coord],
  startPoint: Coord,
  endPoint: Coord,
): seq[Coord] =
  var seen = initHashSet[(Coord)]()
  var hq = initHeapQueue[HeapQueueItem]()
  hq.push((startPoint, (0,0), 0, @[startPoint]))

  while (hq.len > 0):
    let (p,pd,s,pa) = hq.pop()

    if (p == endPoint):
      return pa

    if (seen.contains((p))):
      continue
    seen.incl((p))

    for direction in concat(@[pd],DIRECTIONS):
      let np = p + direction
    
      if (not toSeq(grid.values).contains(np)):
        continue

      var npa = pa
      npa.add(np)

      hq.push((np, direction, s+1, npa))

