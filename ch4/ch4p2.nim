import std/os
import std/nre
import std/strutils

let fileContent = readFile(paramStr(1));

let xmasArray = splitLines(fileContent)

var sum = 0;
for y in 0..<xmasArray.len:
    var x = find(xmasArray[y], "A")
    while (x != -1):
        if (x-1 >= 0 and x+1 < xmasArray[0].len and
            y-1 >= 0 and y+1 < xmasArray.len):
            if ((xmasArray[y-1][x-1] == 'M' and xmasArray[y+1][x+1] == 'S') or
                (xmasArray[y-1][x-1] == 'S' and xmasArray[y+1][x+1] == 'M')):
                if ((xmasArray[y-1][x+1] == 'M' and xmasArray[y+1][x-1] == 'S') or
                    (xmasArray[y-1][x+1] == 'S' and xmasArray[y+1][x-1] == 'M')):
                        sum += 1
        x = find(xmasArray[y], "A", x+1)
echo sum