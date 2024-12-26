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

type Path = seq[Coord]

proc pathFind(
  grid: Table[char, Coord],
  startPoint: Coord,
  endPoint: Coord,
): seq[Path] =
  var seen = initHashSet[HashSet[Coord]]()
  var hq = initHeapQueue[HeapQueueItem]()
  hq.push((startPoint, (0,0), 0, @[startPoint]))

  var finalPaths: seq[seq[Coord]] = @[]
  while (hq.len > 0):
    let (p,pd,s,pa) = hq.pop()

    if (p == endPoint):
      if (finalPaths.len == 0):
        finalPaths.add(pa)
      else:
        if (pa.len < finalPaths[0].len):
          finalPaths = @[]
        if (pa.len <= finalPaths[0].len):
          finalPaths.add(pa)
      continue

    if (seen.contains(toHashSet(pa))):
      continue
    seen.incl(toHashSet(pa))

    for direction in @[(0, 1), (0, -1), (-1, 0), (1, 0)]:
      let np = p + direction
      let ssc = (endPoint - np)
      let ss = abs(ssc.x)+abs(ssc.y)
      let ns = if (direction == pd): ss else: ss+1
    
      if (not toSeq(grid.values).contains(np)):
        continue

      var npa = pa
      npa.add(np)

      hq.push((np, direction, ns, npa))
  return finalPaths

type Directions = seq[char]

proc `<` (a: Directions, b: Directions): bool = a.len < b.len

proc pathsToDirections(paths: seq[Path]): seq[Directions] =
  var directions: seq[seq[char]] = @[]
  for path in paths:
    directions.add(@[])

    var pc = path[0]
    for c in path[1..^1]:
      let d = c - pc
      if (d == (0,1)):
        directions[^1].add('v')
      elif (d == (0,-1)):
        directions[^1].add('^')
      elif (d == (-1,0)):
        directions[^1].add('<')
      elif (d == (1,0)):
        directions[^1].add('>')
      
      pc = c
    directions[^1].add('A')

  return directions

var cache = initTable[(string, int), int]()

proc findPathLength(
  sequencep: seq[char], 
  levelKeypads: seq[Table[char, Coord]], 
  level = 0, 
  maxLevel = 2
): int =
  var sequence = sequencep
  let seqStr = sequence.join("")
  if (seqStr, level) in cache:
    return cache[(seqStr, level)]

  let keypad = levelKeypads[level]
  sequence = @['A'] & sequence

  var totalLength = 0
  for i in 0..<sequence.len-1:
    let (start, endd) = (sequence[i], sequence[i + 1])
    let pathsg = pathFind(keypad, keypad[start], keypad[endd])
    let paths = pathsToDirections(pathsg)

    var minLength = high(int)
    for path in paths:
      let pathLength = if level < maxLevel:
        findPathLength(path, levelKeypads, level + 1, maxLevel)
      else:
        path.len
      if pathLength < minLength:
        minLength = pathLength
    totalLength += minLength

  cache[(seqStr, level)] = totalLength
  return totalLength

var sum = 0
for line in lines:
  let levelKeyPads = @[numpad].concat(toSeq(0..<25).mapIt(directionalPad))
  sum += parseInt(line[0..^2]) * findPathLength(toSeq(line), levelKeypads, 0, 25)
echo sum