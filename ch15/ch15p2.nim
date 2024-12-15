import std/os
import std/sets
import std/strutils
import std/sequtils

type Coord = tuple
  x: int
  y: int

proc `+` (a: Coord, b: Coord): Coord = (a.x + b.x, a.y + b.y)
proc `-` (a: Coord, b: Coord): Coord = (a.x - b.x, a.y - b.y)

let fileContent = readFile(paramStr(1));
let data = split(fileContent, "\n\n")

proc convertGrid(grid: seq[string]): seq[string] =
  var newGrid: seq[string] = @[]
  for y,line in grid:
    var newLine = ""
    for x,c in line:
      case (c)
        of '#':
          newLine = newLine & "##"
        of 'O':
          newLine = newLine & "[]"
        of '.':
          newLine = newLine & ".."
        of '@':
          newLine = newLine & "@."
        else:
          discard
    newGrid.add(newLine)
  return newGrid

proc resolveBoxes(
  boxes: var HashSet[Coord],
  walls: HashSet[Coord],
  robot: Coord,
  direction: Coord
): bool =
  var newBoxes = boxes
  var newBoxesS: seq[Coord] = @[]

  # Firstly we need the box
  let startingBox = (if boxes.contains(robot): boxes[robot] else: boxes[(robot.x-1, robot.y)])
  var s: seq[Coord] = @[startingBox]
  while (s.len > 0):
    # echo s

    let box = s.pop()
    # Move the box
    let newBox = box + direction
    newBoxes.excl(box)
    newBoxesS.add(newBox)

    if (walls.contains(newBox) or walls.contains((newBox.x+1, newBox.y))):
      # revert everything
      return false

    # Does the box collide with other boxes
    if (boxes.contains(newBox)):
      s.add(boxes[newBox])

    if (abs(direction.y) == 1):
      if (boxes.contains((newBox.x+1, newBox.y))):
        s.add(boxes[(newBox.x+1, newBox.y)])
      if (boxes.contains((newBox.x-1, newBox.y))):
        s.add(boxes[(newBox.x-1, newBox.y)])
    elif (direction.x == 1):
      if (boxes.contains((newBox.x+1, newBox.y))):
        s.add(boxes[(newBox.x+1, newBox.y)])
    else:
      if (boxes.contains((newBox.x-1, newBox.y))):
        s.add(boxes[(newBox.x-1, newBox.y)])
  
  for box in newBoxesS:
    newBoxes.incl(box)
  boxes = newBoxes
  return true

proc move(
  robot: var Coord,
  walls: var HashSet[Coord],
  boxes: var HashSet[Coord],
  direction: Coord
) =
  let newRobot = robot + direction
  if (walls.contains(newRobot)):
    return

  if (not boxes.contains(newRobot) and
      not boxes.contains((newRobot.x-1, newRobot.y))): 
    robot = newRobot
    return

  if (resolveBoxes(boxes, walls, newRobot, direction)):
    robot = newRobot

proc printGrid(
  grid: seq[string],
  robot: Coord,
  walls: Hashset[Coord],
  boxes: HashSet[Coord]
) =
  for y in 0..<grid.len:
    var x = 0
    while x < grid[0].len:
      if (robot == (x,y)):
        stdout.write '@'
      elif (walls.contains((x,y))):
        stdout.write '#'
      elif (boxes.contains((x,y))):
        stdout.write '['
        stdout.write ']'
        x += 1
      else:
        stdout.write '.'
      x += 1
    echo ""
  echo ""

let gridOrig = splitLines(data[0])
let instructions = data[1]

let grid = convertGrid(gridOrig)

var robot: Coord;
var walls = initHashSet[Coord]()
var boxes = initHashSet[Coord]()

for y,line in grid:
  for x,c in line:
    case (c):
      of '#':
        walls.incl((x,y))
      of '[':
        boxes.incl((x,y))
      of '@':
        robot = (x,y)
      else:
        discard

printGrid(grid, robot, walls, boxes)

for instruction in instructions:
  echo instruction
  case (instruction):
    of '^':
      move(robot, walls, boxes, (0,-1))
    of 'v':
      move(robot, walls, boxes, (0,1))
    of '<':
      move(robot, walls, boxes, (-1,0))
    of '>':
      move(robot, walls, boxes, (1,0))
    else:
      discard
  
printGrid(grid, robot, walls, boxes)

var sum = 0
for rock in boxes:
  sum += rock.y * 100 + rock.x
echo sum

