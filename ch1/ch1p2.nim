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

var previous_sum = 0
var total = 0
var p1 = 0
for i, n1 in list1.pairs:
    var sum = 0;
    while (p1 < list2.len and list2[p1] <= n1):
        if (list2[p1] == n1):
            sum.inc()
        p1.inc()

    if (i > 0 and list1[i-1] == n1):
        sum = previous_sum
    else:
        previous_sum = sum
    
    total += n1 * sum
echo(total)

