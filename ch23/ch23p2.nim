import std/os
import std/sets
import std/tables
import std/sequtils
import std/strutils
import std/algorithm

let fileContent = readFile(paramStr(1));
let lines = splitLines(fileContent)

var computers = initTable[string, seq[string]]()
for line in lines:
  let c = line.split("-")
  discard computers.hasKeyOrPut(c[0], @[])
  computers[c[0]].add(c[1])
  discard computers.hasKeyOrPut(c[1], @[])
  computers[c[1]].add(c[0])

var triConnections = initHashSet[HashSet[string]]()
for computer,connections in computers:
  if (connections.len < 2):
    continue

  let cc = toHashSet(connections)
  for connection in connections:
    for connection2 in (cc * toHashSet(computers[connection])):
      if computers[connection2].contains(computer):
        let x = toHashSet(@[computer, connection, connection2])
        triConnections.incl(x)

proc tryAdd(
  computers: Table[string, seq[string]],
  nConnections: HashSet[HashSet[string]]
): HashSet[HashSet[string]] =
  var valid = initHashSet[HashSet[string]]()
  for nConnection in nConnections:
    for computer,connections in computers:
      let nSet = nConnection + toHashSet(@[computer])
      if (nSet.len == nConnection.len):
        continue
      if (all(toSeq(nSet), proc (c: string): bool = toHashSet(computers[c].concat(@[c])) * nSet == nSet)):
        valid.incl(nSet)
  return valid

var pConnections: HashSet[HashSet[string]]
var connections = tryAdd(computers, triConnections)
while connections.len > 0:
  pConnections = connections
  connections = tryAdd(computers, connections)

let x = toSeq(toSeq(pConnections)[0])
echo sorted(x).join(",")

    