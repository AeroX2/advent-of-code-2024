import std/os
import std/nre
import std/math
import std/strutils
import std/sequtils

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

import cairo

proc display(frame: int) =
  for i in 0..<robots.len:
    robots[i].update()

  var grid: array[103, array[101, int]];
  for robot in robots:
    grid[robot.p.y][robot.p.x] = 1

  ## Called every frame by main while loop

  # draw shiny sphere on gradient background
  var surface = imageSurfaceCreate(FORMAT_ARGB32, int32(WIDTH), int32(HEIGHT))
  let cr = surface.create()

  for y, row in grid:
    for x, value in row:
      if value == 1:
        cr.setSourceRGB(0, 0, 0)  # Black for 1
      else:
        cr.setSourceRGB(1, 1, 1)  # White for 0
      cr.rectangle(float(x), float(y), 1.0, 1.0)
      cr.fill()
  
  discard surface.writeToPng("images/" & intToStr(frame) & ".png")

for i in 0..1000000:
  display(i)