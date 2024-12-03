import std/os
import std/nre
import std/strutils

let fileContent = readFile(paramStr(1));

var sum = 0
let pattern = re"(mul\(([0-9]+),([0-9]+)\))|(do(n't)?\(\))"

var multiplyEnabled = true;
for m in findIter(fileContent, pattern):
    if (m.match == "do()"):
        multiplyEnabled = true
    elif (m.match == "don't()"):
        multiplyEnabled = false
    elif (multiplyEnabled):
        let a = m.captures[1]
        let b = m.captures[2]
        sum += parseInt(a) * parseInt(b)
echo sum