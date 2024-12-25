import std/os
import std/nre
import std/sugar
import std/tables
import std/strutils
import std/sequtils
import std/algorithm

let fileContent = readFile(paramStr(1));
let data = split(fileContent, "\n\n")

let initialSolved = splitLines(data[0])
let unsolvedEquationsLines = splitLines(data[1])

var solved = initTable[string, int]()
for s in initialSolved:
  let x = s.split(": ")
  solved[x[0]] = (if x[1] == "1": 1 else: 0)

type Equation = tuple
  x: string
  op: string
  y: string
  z: string

var unsolvedEquations: seq[Equation] = @[]
let p = re"(.+) (AND|OR|XOR) (.+) -> (.+)"
for equationLine in unsolvedEquationsLines:
  let m = equationLine.match(p).get()
  unsolvedEquations.add((
    x: m.captures[0],
    op: m.captures[1],
    y: m.captures[2],
    z: m.captures[3]
  ))

while unsolvedEquations.len > 0:
  echo unsolvedEquations
  var removableEquations: seq[int] = @[]
  for i,equation in unsolvedEquations:
    let (x,op,y,z) = equation
    if (not (solved.contains(x) and solved.contains(y))):
      continue
    
    case (op):
      of "AND":
        solved[z] = solved[x] and solved[y]
      of "OR":
        solved[z] = solved[x] or solved[y]
      of "XOR":
        solved[z] = solved[x] xor solved[y]
      else:
        discard
    removableEquations.add(i)
  
  for equation in reversed(removableEquations):
    unsolvedEquations.delete(equation)
    
let z = collect(newSeq):
  for k in solved.keys:
    if k[0] == 'z':
      k
let zs = sorted(z, Descending)
let mzs = zs.mapIt(solved[it])
let final = mzs.foldl((a shl 1) or b, 0)
echo final
