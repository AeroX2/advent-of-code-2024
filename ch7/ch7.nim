import std/os
import std/math
import std/strutils
import std/algorithm
import std/sequtils
import std/strformat

let fileContent = readFile(paramStr(1));

proc helper(values: seq[int], final: int, count = 0, path: string): bool =
    # echo values, count
    if (values.len <= 0):
        return count == final

    var newValues = values
    var v = newValues.pop()

    return helper(newValues, final, count + v, path & fmt" + {v}") or
           helper(newValues, final, count * v, path & fmt" * {v}")

var sum = 0
for line in splitLines(fileContent):
    let d = line.split(": ")
    let final = parseInt(d[0])
    let values = reversed(d[1].split(" ").mapIt(parseInt(it)))

    # echo final, " ", values

    var pValues = values
    let q = pValues.pop()
    if (helper(pValues, final, q, fmt"{q}")):
        echo line
        sum += final
echo sum




