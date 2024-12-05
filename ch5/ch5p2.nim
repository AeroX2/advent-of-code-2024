import std/os
import std/sequtils
import std/strutils
import std/tables

let fileContent = readFile(paramStr(1));
let data = split(fileContent, "\n\n")
echo data

let rules = splitLines(data[0])
let updates = splitLines(data[1]).mapIt(split(it, ",").mapIt(parseInt(it)))

var ruleMap = initTable[int, seq[int]]()
for rule in rules:
    let d = split(rule, "|")
    let before = parseInt(d[0])
    let after = parseInt(d[1])
    if (not ruleMap.hasKey(before)):
        ruleMap[before] = @[]
    ruleMap[before].add(after)

var sum = 0
for update in updates:
    var valid = true
    var seen = initTable[int, bool]()
    for n in update:
        if (ruleMap.hasKey(n)):
            for x in ruleMap[n]:
                if (seen.hasKey(x)):
                    echo "invalid ",x," ",n
                    valid = false
                    break
            if (not valid):
                break
        seen[n] = true

    if not valid:
        # Order this somehow?
        echo update

        var newUpdate = update;

        # This is absolute garbage, pretty sure I'm just brute forcing
        for _ in 1..50:
            var seen = initTable[int, int]()
            for i in 0..<newUpdate.len:
                var ignore = false
                let n = newUpdate[i]
                if (ruleMap.hasKey(n)):
                    for x in ruleMap[n]:
                        if (seen.hasKey(x)):
                            # Swap?
                            # echo "Swapping ",newUpdate[i]," ",newUpdate[seen[x]]

                            let a = newUpdate[i]
                            newUpdate[i] = newUpdate[seen[x]]
                            newUpdate[seen[x]] = a

                            let b = seen[x]
                            seen[x] = i
                            seen[n] = b

                            ignore = true

                            # echo newUpdate
                if not ignore:
                    seen[n] = i

        # echo "N",newUpdate
        sum += newUpdate[newUpdate.len div 2]

echo sum