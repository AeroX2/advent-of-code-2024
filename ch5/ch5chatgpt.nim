import std/os
import std/sequtils
import std/strutils
import std/tables
import std/deques

# Parse input
let fileContent = readFile(paramStr(1))
let data = split(fileContent, "\n\n")

let rules = splitLines(data[0])
let updates = splitLines(data[1]).mapIt(split(it, ",").mapIt(parseInt(it)))

# Build rule map (adjacency list for the graph)
var ruleMap = initTable[int, seq[int]]()
for rule in rules:
    let d = split(rule, "|")
    let before = parseInt(d[0])
    let after = parseInt(d[1])
    if not ruleMap.hasKey(before):
        ruleMap[before] = @[]
    ruleMap[before].add(after)

# Function to perform topological sort
proc topoSort(update: seq[int], ruleMap: Table[int, seq[int]]): seq[int] =
    # Calculate in-degrees for pages in this update
    var inDegree = initTable[int, int]()
    for n in update:
        inDegree[n] = 0

    for n in update:
        if ruleMap.hasKey(n):
            for neighbor in ruleMap[n]:
                if inDegree.hasKey(neighbor):
                    inDegree[neighbor] += 1

    # Initialize a deque for nodes with no incoming edges
    var queue = initDeque[int]()
    for n in update:
        if inDegree[n] == 0:
            queue.addLast(n)

    # Perform topological sort
    var sorted: seq[int] = @[]
    while queue.len > 0:
        let current = queue.popFirst()
        sorted.add(current)

        if ruleMap.hasKey(current):
            for neighbor in ruleMap[current]:
                if inDegree.hasKey(neighbor):
                    inDegree[neighbor] -= 1
                    if inDegree[neighbor] == 0:
                        queue.addLast(neighbor)

    return sorted

# Check and process updates
var sum = 0
for update in updates:
    var valid = true
    var seen = initTable[int, bool]()
    for n in update:
        if ruleMap.hasKey(n):
            for x in ruleMap[n]:
                if seen.hasKey(x):
                    valid = false
                    break
            if not valid:
                break
        seen[n] = true

    if not valid:
        # Reorder invalid updates using topological sort
        let newUpdate = topoSort(update, ruleMap)
        sum += newUpdate[newUpdate.len div 2]

echo sum