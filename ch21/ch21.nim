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

    for direction in DIRECTIONS:
      let np = p + direction
      let ssc = (endPoint - np)
      let ss = abs(ssc.x)+abs(ssc.y)
      let ns = if (direction == pd): ss else: ss+1
    
      if (not toSeq(grid.values).contains(np)):
        continue

      var npa = pa
      npa.add(np)

      hq.push((np, direction, ns, npa))

proc convertPadPaths(t: Table[(char, char), seq[Coord]]): Table[(char, char), string] = 
  var f = initTable[(char, char), string]()
  for k in t.keys:
    var s = ""

    var pc = t[k][0]
    for c in t[k][1..^1]:
      let pd = c - pc
      if (pd == (0,1)):
        s = s & 'v'
      elif (pd == (0,-1)):
        s = s & '^'
      elif (pd == (-1,0)):
        s = s & '<'
      elif (pd == (1,0)):
        s = s & '>'
      else:
        raiseAssert("Invalid")
      pc = c

    f[k] = s & "A"

  return f

proc parse(t: Table[(char, char), string], s: string, ppc: char = 'A'): string =
  var f = ""
  var pc = ppc
  for c in s:
    f = f & t[(pc,c)]
    pc = c
  return f

proc permutations(sp: string): seq[string] =
  var result = initSet[string]()  # A set to store unique permutations

  proc permute(current: string, remaining: string) =
    if remaining.len == 0:
      result.incl(current)  # If no remaining characters, add the current permutation to the set
    else:
      for i in 0..<remaining.len:
        # Skip duplicate characters in the remaining string
        if i > 0 and remaining[i] == remaining[i-1]:
          continue
        # Choose the character at position i and permute the rest
        permute(current & remaining[i], remaining[0..i-1] & remaining[i+1..^1])

  # Sort the string to group identical characters together
  var s = sp
  s.sort()
  permute("", s)
  return result.toSeq()  # Convert the set to a sequence for output

proc permuteAndParse(t: Table[(char, char), string], sp: string): string =
  var s = sp

  var minS = ""
  var i = s.find("A")
  while (i != -1):
    let ps = s[0..i-1]
    var ms = (1000000, "")

    let ppp = permutations(ps)
    for permutation in ppp:
      let q = parse(t, permutation & "A")
      if (q.len < ms[0]):
        ms = (q.len, q)

    minS = minS & ms[1]

    s = s[i+1..^1]
    i = s.find("A")
  
  return minS


var numpadPaths = initTable[(char, char), seq[Coord]]()
for v in numpad.keys:
  for v2 in numpad.keys:
    numpadPaths[(v,v2)] = pathFind(numpad, numpad[v], numpad[v2])

var directionalPadPaths = initTable[(char, char), seq[Coord]]()
for v in directionalPad.keys:
  for v2 in directionalPad.keys:
    directionalPadPaths[(v,v2)] = pathFind(directionalPad, directionalPad[v], directionalPad[v2])

let numpadPathsStr = convertPadPaths(numpadPaths)
var directionalPadPathsStr = convertPadPaths(directionalPadPaths)

var sum = 0
for line in lines:
  echo line
  var f = parse(numpadPathsStr, line)
  echo f
  f = permuteAndParse(directionalPadPathsStr, f)
  echo f
  f = permuteAndParse(directionalPadPathsStr, f)
  echo f

  var g = f.len * parseInt(line[0..^2])
  echo f.len
  echo parseInt(line[0..^2])
  sum += g
echo sum