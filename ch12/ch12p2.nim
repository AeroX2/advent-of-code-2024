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

let DIRECTIONS: seq[Coord] = @[(0, 1), (0, -1), (-1, 0), (1, 0)]

let fileContent = readFile(paramStr(1));
let garden = splitLines(fileContent)

type FloodFillReturn = tuple
    plot: HashSet[Coord]
    perimeter: Table[Coord, HashSet[Coord]]

proc floodFill(plant: char, garden: seq[string], start: Coord): FloodFillReturn =
    var plot = initHashSet[Coord]()
    var perimeter = initTable[Coord, HashSet[Coord]]()

    var queue = initHeapQueue[(Coord, Coord)]()
    queue.push(((0,0), start))
    while queue.len > 0:
        let (direction, pos) = queue.pop()

        if (pos.x < 0 or pos.x > garden[0].len-1 or
            pos.y < 0 or pos.y > garden.len-1):
            discard perimeter.hasKeyOrPut(direction, initHashSet[Coord]())
            perimeter[direction].incl(pos)
            continue

        let val = garden[pos.y][pos.x]
        if (val != plant):
            discard perimeter.hasKeyOrPut(direction, initHashSet[Coord]())
            perimeter[direction].incl(pos)
            continue
        
        if (plot.contains(pos)):
            continue
        plot.incl(pos) 

        for d in DIRECTIONS:
            let newPos = pos + d
            queue.push((d, newPos))
    
    return (plot, perimeter)

proc look(ph: HashSet[Coord], start: Coord, direction: Coord): HashSet[Coord]  = 
    var c = start
    var seen = initHashSet[Coord]()
    while true:
        seen.incl(c)
        c = c + direction
        if (not ph.contains(c)):
            break

    return seen


proc sidesFromPerimeter(perimeter: Table[Coord, HashSet[Coord]]): int = 
    var sides = 0
    for d,ph in perimeter:
        var ignore = initHashSet[Coord]();
        for p in ph:
            if (ignore.contains(p)):
                continue
            ignore.incl(p)
            sides += 1

            if (abs(d.x) == 0 and abs(d.y) == 1):
                ignore = ignore + look(ph, p, (-1, 0))
                ignore = ignore + look(ph, p, (1, 0))
            elif (abs(d.x) == 1 and abs(d.y) == 0):
                ignore = ignore + look(ph, p, (0, -1))
                ignore = ignore + look(ph, p, (0, 1))

    return sides


var sum = 0
var seenPlant = initTable[char, HashSet[Coord]]()
for y,line in garden:
    for x,plant in line:
        var plots: HashSet[Coord]
        if (seenPlant.contains(plant)):
            plots = seenPlant[plant]
            if (plots.contains((x,y))):
                continue

        let (plot, perimeter) = floodFill(plant, garden, (x,y))
        seenPlant[plant] = plots + plot

        let sides = sidesFromPerimeter(perimeter)
        echo "Plant: ", plant, " Area: ", plot.len, " Sides: ", sides
        sum += plot.len * sides
echo sum

