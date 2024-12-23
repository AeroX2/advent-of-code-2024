import std/os
import std/sets
import std/tables
import std/sequtils
import std/strutils
import std/algorithm
import std/strformat

let fileContent = readFile(paramStr(1));
let lines = splitLines(fileContent)

var computers = initTable[string, seq[string]]()
for line in lines:
  let c = line.split("-")
  discard computers.hasKeyOrPut(c[0], @[])
  computers[c[0]].add(c[1])
  discard computers.hasKeyOrPut(c[1], @[])
  computers[c[1]].add(c[0])

var triConnections = initHashSet[seq[string]]()
for computer,connections in computers:
  if (connections.len < 2):
    continue
  if (not (computer[0] == 't')):
    continue

  let cc = toHashSet(connections)
  for connection in connections:
    for connection2 in (cc * toHashSet(computers[connection])):
      if computers[connection2].contains(computer):
        let x = sorted(@[computer, connection, connection2])
        triConnections.incl(x)

echo triConnections
echo triConnections.len
