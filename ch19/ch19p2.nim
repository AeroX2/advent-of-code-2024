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

var memo = initTable[string, int]()
proc check(design: string, patterns: seq[string]): int =
  if (memo.contains(design)):
    return memo[design]

  if (design.len == 0):
    return 1
  
  memo[design] = 0
  for pattern in patterns:
    if (design.len < pattern.len or pattern != design[0..pattern.len-1]):
      continue
    let r = check(design[pattern.len..^1], patterns)
    memo[design] += r

  return memo[design]

var sum = 0
for design in designs:
  memo = initTable[string, int]()
  let r = check(design, towelPatterns)
  sum += r
echo sum

