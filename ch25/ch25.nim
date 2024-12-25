import std/os
import std/nre
import std/sugar
import std/tables
import std/strutils
import std/sequtils
import std/algorithm

let fileContent = readFile(paramStr(1));
let locksAndKeys = split(fileContent, "\n\n")

var locks: seq[array[5,int]] = @[]
var keys: seq[array[5,int]] = @[]
for lockOrKeyLineRaw in locksAndKeys:
  let lockOrKeyLine = splitLines(lockOrKeyLineRaw)
  let isKey = lockOrKeyLine[0][0] == '#'

  var lockOrKey = [0,0,0,0,0]
  for line in lockOrKeyLine:
    for x,c in line:
      if c == '#':
        lockOrKey[x] += 1
  
  if (isKey):
    keys.add(lockOrKey)
  else:
    locks.add(lockOrKey)

echo keys
echo locks

var sum = 0
for lock in locks:
  for key in keys:
    var valid = true
    for i in 0..4:
      if (lock[i]+key[i] > 7):
        valid = false
        break
    if (valid):
      sum += 1
echo sum

