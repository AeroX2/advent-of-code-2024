import std/os
import std/strutils
import std/sequtils

let fileContent = readFile(paramStr(1));
var stones = splitWhitespace(fileContent).mapIt(parseInt(it))

for blink in 1..25:
    var newStones: seq[int] = @[]
    for stone in stones:
        let stoneStr = intToStr(stone)
        if stone == 0:
            newStones.add(1)
        elif (stoneStr.len mod 2 == 0):
            newStones.add(parseInt(stoneStr[0..(stoneStr.len div 2)-1]))
            newStones.add(parseInt(stoneStr[(stoneStr.len div 2)..^1]))
        else:
            newStones.add(stone * 2024)
    # echo newStones
    stones = newStones
echo stones.len

