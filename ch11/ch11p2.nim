import std/os
import std/strutils
import std/sequtils
import std/tables

let fileContent = readFile(paramStr(1));
let stones = splitWhitespace(fileContent).mapIt(parseInt(it))

var stoneToAmount = initTable[(int, int), int]()
proc blink(steps: int, stone: int): int =
    if (steps <= 0):
        return 1

    if (stoneToAmount.contains((steps, stone))):
        return stoneToAmount[(steps, stone)]
    
    let stoneStr = intToStr(stone)
    var v = (
        if stone == 0:
            blink(steps-1, 1)
        elif (stoneStr.len mod 2 == 0):
            blink(steps-1, parseInt(stoneStr[0..(stoneStr.len div 2)-1])) +
            blink(steps-1, parseInt(stoneStr[(stoneStr.len div 2)..^1]))
        else:
            blink(steps-1, stone * 2024)
    )
    stoneToAmount[(steps, stone)] = v
    return v 

proc validate(steps: int, stonesp: seq[int]): int =
    var stones = stonesp
    for blink in 1..steps:
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
    return stones.len


var sum = 0
for stone in stones:
    sum += blink(75, stone)
# echo stoneToAmount
echo sum

# for k, v in stoneToAmount:
#     let (steps, stone) = k
#     let av = validate(steps, @[stone])
#     if (av != v):
#         echo "Error at"
#         echo steps, " ", stone, " ", v, " ", av
#         break

# echo validate(6, @[125])
# echo validate(6, @[17])
    
