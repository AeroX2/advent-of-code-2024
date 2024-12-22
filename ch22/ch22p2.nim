import std/os
import std/tables
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

proc calcChanges(on: int): Table[seq[int], int] =
  var t = initTable[seq[int], int]()

  var c: seq[int] = @[]

  var np = on
  var n = calcSecret(np, 1)
  for i in 0..<2000:
    let pp = np mod 10
    let p = n mod 10
    let pc = p - pp

    c.add(pc)
    if (c.len == 4):
      if (not t.contains(c)):
        t[c] = p
      c = c[1..^1]
    
    np = n
    n = calcSecret(n, 1)
  return t

var t = initTable[seq[int], int]()
for line in lines:
  var changes = calcChanges(parseInt(line))
  for change, price in changes:
    discard t.hasKeyOrPut(change, 0)
    t[change] += price

var maxBananas: (int, seq[int]) = (0, @[])
for k, v in t:
  if (v > maxBananas[0]):
    maxBananas = (v, k)
echo maxBananas