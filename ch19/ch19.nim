import std/os
import std/tables
import std/strutils
import std/strformat
import std/algorithm

let fileContent = readFile(paramStr(1));
let data = split(fileContent, "\n\n")

var towelPatterns = data[0].split(", ")
towelPatterns.sort()
towelPatterns.reverse()
let designs = splitLines(data[1])

var memo = initTable[string, bool]()
proc check(design: string, patterns: seq[string], path = ""): (bool, string) =
  if (memo.contains(design)):
    return (memo[design], "")

  if (design.len == 0):
    memo[design] = true
    return (true, path)
  
  for pattern in patterns:
    if (design.len < pattern.len or pattern != design[0..pattern.len-1]):
      continue
    let r = check(design[pattern.len..^1], patterns, path & fmt"({pattern})")
    if (r[0]):
      return (true, r[1])

  memo[design] = false
  return (false, "")

var sum = 0
for design in designs:
  memo = initTable[string, bool]()
  let r = check(design, towelPatterns)
  if (r[0]):
    echo design
    echo r[1]
    sum += 1
echo sum

