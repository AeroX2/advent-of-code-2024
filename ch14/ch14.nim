import std/os
import std/nre
import std/math
import std/strutils

let WIDTH = 101
let HEIGHT = 103

type Coord = tuple
    x: int
    y: int

proc `+` (a: Coord, b: Coord): Coord = (a.x + b.x, a.y + b.y)
proc `-` (a: Coord, b: Coord): Coord = (a.x - b.x, a.y - b.y)

type Robot = tuple
  p: Coord
  v: Coord

proc update(r: var Robot) = 
  r = (r.p + r.v, r.v)
  if (r.p.x < 0): r.p.x = WIDTH + r.p.x
  if (r.p.x >= WIDTH): r.p.x = r.p.x - WIDTH
  if (r.p.y < 0): r.p.y = HEIGHT + r.p.y
  if (r.p.y >= HEIGHT): r.p.y = r.p.y - HEIGHT

let fileContent = readFile(paramStr(1));
let robotsL = splitLines(fileContent)

proc countQuadrant(robots: seq[Robot], qp: Coord, qs: Coord): int =
  var sum = 0
  for y in qp.y..<qp.y+qs.y:
    for x in qp.x..<qp.x+qs.x:
      for robot in robots:
        if (robot.p == (x,y)):
          sum += 1
  return sum

let p = re"p=(-?[0-9]+),(-?[0-9]+) v=(-?[0-9]+),(-?[0-9]+)"
var robots: seq[Robot] = @[]
for line in robotsL:
  let m = line.match(p).get

  let p = (
    parseInt(m.captures[0]),
    parseInt(m.captures[1]),
  )
  let v = (
    parseInt(m.captures[2]),
    parseInt(m.captures[3]),
  )

  robots.add((p, v))

for step in 1..100:
  for i in 0..<robots.len:
    robots[i].update()

var grid: seq[string] = @[]
for i in 0..<HEIGHT:
  grid.add(".".repeat(WIDTH))

for robot in robots:
  grid[robot.p.y][robot.p.x] = '1'

for line in grid:
  echo line

let wh = WIDTH div 2
let hh = HEIGHT div 2

var sum = countQuadrant(robots, (0,0), (wh,hh))
sum *= countQuadrant(robots, (wh+1,0), (wh,hh))
sum *= countQuadrant(robots, (0,hh+1), (wh,hh))
sum *= countQuadrant(robots, (wh+1,hh+1), (wh,hh))
echo sum