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
    perimeter: seq[Coord]

proc floodFill(plant: char, garden: seq[string], start: Coord): FloodFillReturn =
    var plot = initHashSet[Coord]()
    var perimeter: seq[Coord] = @[]

    var queue = initHeapQueue[Coord]()
    queue.push(start)
    while queue.len > 0:
        let pos = queue.pop()

        if (pos.x < 0 or pos.x > garden[0].len-1 or
            pos.y < 0 or pos.y > garden.len-1):
            perimeter.add(pos) 
            continue

        let val = garden[pos.y][pos.x]
        if (val != plant):
            perimeter.add(pos) 
            continue
        
        if (plot.contains(pos)):
            continue
        plot.incl(pos) 

        for d in DIRECTIONS:
            let newPos = pos + d
            queue.push(newPos)
    
    return (plot, perimeter)

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

        echo "Plant: ", plant, " Area: ", plot.len, " Perimeter: ", perimeter.len
        sum += plot.len * perimeter.len
echo sum

