import std/os
import std/sets
import std/strutils

type Coord = tuple
    x: int
    y: int

proc `+` (a: Coord, b: Coord): Coord = (a.x + b.x, a.y + b.y)
proc `-` (a: Coord, b: Coord): Coord = (a.x - b.x, a.y - b.y)

let fileContent = readFile(paramStr(1));
let data = split(fileContent, "\n\n")

proc resolveBoxes(
  boxes: var HashSet[Coord],
  walls: HashSet[Coord],
  robot: Coord,
  direction: Coord
): bool =
  var item = boxes[robot]
  while true:
    if (walls.contains(item)):
      return false

    if (boxes.contains(item)):
      item = boxes[item] + direction
      continue
    
    boxes.excl(robot)
    boxes.incl(item)
    break
  return true


proc move(
  robot: var Coord,
  walls: var HashSet[Coord],
  boxes: var Hashset[Coord],
  direction: Coord
) =
  let newRobot = robot + direction
  if (walls.contains(newRobot)):
    return

  if (not boxes.contains(newRobot)):
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
    for x in 0..<grid[0].len:
      if (robot == (x,y)):
        stdout.write '@'
      elif (walls.contains((x,y))):
        stdout.write '#'
      elif (boxes.contains((x,y))):
        stdout.write 'O'
      else:
        stdout.write '.'
    echo ""
  echo ""


let grid = splitLines(data[0])
let instructions = data[1]

var robot: Coord;
var walls = initHashSet[Coord]()
var boxes = initHashSet[Coord]()

for y,line in grid:
  for x,c in line:
    case (c):
      of '#':
        walls.incl((x,y))
      of 'O':
        boxes.incl((x,y))
      of '@':
        robot = (x,y)
      else:
        discard

for instruction in instructions:
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

