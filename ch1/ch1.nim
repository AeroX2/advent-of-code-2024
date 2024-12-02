import macros
import sequtils
import std/os
import std/strutils
import std/algorithm

macro first[T](s:openArray[T],l:static[int]):untyped =       
  result = newNimNode(nnkPar)
  for i in 0..<l:            
    result.add nnkBracketExpr.newTree(s,newLit(i))   

let fileContent = readFile(paramStr(1));

var list1: seq[int]
var list2: seq[int]
for line in splitLines(fileContent):
    if line.len > 0:
        let (a,b) = line.splitWhitespace().first(2)
        list1.add(parseInt(a))
        list2.add(parseInt(b))

list1.sort()
list2.sort()
echo(list1)
echo(list2)

var sum = 0
for i in 0 ..< list1.len:
    sum += abs(list1[i] - list2[i])
echo(sum)