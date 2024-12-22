import std/os
import std/strutils

let fileContent = readFile(paramStr(1));
let lines = splitLines(fileContent)

proc calcSecret(np: int, steps: int): int =
  var n = np
  for s in 0..<steps:
    var nn = n * 64
    n = n xor nn
    n = n mod 16777216

    nn = n div 32
    n = n xor nn
    n = n mod 16777216

    nn = n * 2048
    n = n xor nn
    n = n mod 16777216
  return n

var sum = 0
for line in lines:
  sum += calcSecret(parseInt(line), 2000)
echo sum