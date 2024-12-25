import std/os
import std/nre
import std/sets
import std/sugar
import std/tables
import std/strutils
import std/sequtils
import std/strformat
import std/algorithm

let fileContent = readFile(paramStr(1));
let data = split(fileContent, "\n\n")

let initialSolved = splitLines(data[0])
let unsolvedEquationsLines = splitLines(data[1])

type Equation = tuple
  x: string
  op: string
  y: string
  z: string

var equationOutputsToInputs = initTable[string, Equation]()
let p = re"(.+) (AND|OR|XOR) (.+) -> (.+)"
for equationLine in unsolvedEquationsLines:
  let m = equationLine.match(p).get()
  equationOutputsToInputs[m.captures[3]] = (
    x: m.captures[0],
    op: m.captures[1],
    y: m.captures[2],
    z: m.captures[3]
  )

proc follow(
  k: string,
  equationOutputsToInputs: Table[string, Equation]
): (seq[string], seq[string]) =
  if (k[0] == 'x'):
    return (@[k],@[])
  if (k[0] == 'y'):
    return (@[],@[k])

  let (x,_,y,_) = equationOutputsToInputs[k]
  var (xs, ys) = follow(x, equationOutputsToInputs)
  let (xs2, ys2) = follow(y, equationOutputsToInputs)
  xs.add(x)
  ys.add(x)

  return (xs.concat(xs2), ys.concat(ys2))

proc track(
  k: string,
  equationOutputsToInputs: Table[string, Equation]
) = 
  let (x,_,y,z) = equationOutputsToInputs[k]
  echo x

let ak = sorted(
  collect(
  for k in equationOutputsToInputs.keys:
    k
  )
)
let zk = sorted(
  collect(
  for k in equationOutputsToInputs.keys:
    if (k[0] == 'z'):
      k
  )
)

# var mostIncorrectXs = initHashSet[string]()
# var mostIncorrectYs = initHashSet[string]()
# for k in zk:
#   let (xs,ys) = follow(k, equationOutputsToInputs)

#   let xsh = toHashSet(xs.filterIt(it[0] == 'x'))
#   let ysh = toHashSet(ys.filterIt(it[0] == 'y'))
#   let tx = toHashSet(toSeq(0..parseInt(k[1..^1])).mapIt(fmt"x{it:0>2}"))
#   let ty = toHashSet(toSeq(0..parseInt(k[1..^1])).mapIt(fmt"y{it:0>2}"))

#   let incorrectXs = (tx - xsh)
#   if (incorrectXs.len > mostIncorrectXs.len):
#     mostIncorrectXs = incorrectXs

#   let incorrectYs = (ty - ysh)
#   if (incorrectYs.len > mostIncorrectYs.len):
#     mostIncorrectYs = incorrectYs

#   let a = sorted(toSeq(tx - xsh))
#   let b = sorted(toSeq(ty - ysh))
#   let c = sorted(toSeq(xsh - tx))
#   let d = sorted(toSeq(ysh - ty))

#   if (a.len > 0):
#     echo "For key ", k
#     echo "Incorrect x values found: ",c
#     echo "Incorrect y values found: ",d
#     echo "Missing x values found: ",a
#     echo "Missing y values found: ",b
#     echo xs
#     echo ys
#     echo ""

var xyk: seq[string] = @[]
for i in 0..44:
  xyk.add(fmt"x{i:0>2}")
  xyk.add(fmt"y{i:0>2}")

proc generateDotGraph(
  equationOutputsToInputs: Table[string, Equation]
) =
  let hh = xyk.join("\" \"")
  let gg = zk.join("\" \"")

  echo "digraph G {"
  echo "rankdir=TB;"
  echo "{{ rank=same; \"{hh}\" }}".fmt
  echo "{{ rank=same; \"{gg}\" }}".fmt
  for equation in equationOutputsToInputs.values:
    let (x, op, y, z) = equation
    let col = case (op):
      of "XOR":
        "red"
      of "AND":
        "blue"
      of "OR":
        "green"
      else:
        ""

    echo "\"{x}\" -> \"{z}\" [label=\"{op}\", color=\"{col}\"]".fmt
    echo "\"{y}\" -> \"{z}\" [label=\"{op}\", color=\"{col}\"]".fmt
  echo "}"

generateDotGraph(equationOutputsToInputs)

# for k in ak:
#   if (k[0] == 'z'):
#     continue
#   let (xs,ys) = follow(k, equationOutputsToInputs)

#   let xsh = toHashSet(xs.filterIt(it[0] == 'x'))
#   let ysh = toHashSet(ys.filterIt(it[0] == 'y'))
#   if (xsh == toHashSet(@["x00", "x01", "x02", "x03", "x04", "x05", "x06", "x07", "x08"])):
#     echo "A"
#     echo k
#     echo xsh
#     echo ysh
