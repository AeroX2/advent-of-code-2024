import std/os
import std/nre
import std/strutils

let fileContent = readFile(paramStr(1));

var sum = 0
let pattern = re"mul\(([0-9]+),([0-9]+)\)"

for m in findIter(fileContent, pattern):
    let a = m.captures[0]
    let b = m.captures[1]
    sum += parseInt(a) * parseInt(b)
echo sum