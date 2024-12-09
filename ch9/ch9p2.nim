import std/os
import std/strutils
import std/algorithm
import std/assertions

template print(s: varargs[string, `$`]) =
  for x in s:
    stdout.write x

let fileContent = readFile(paramStr(1));

type Block = tuple
    id: int
    startInd: int
    endInd: int

proc printDiskMap(diskMap: seq[Block]): void = 
    for currBlock in diskMap:
        if (currBlock.id == -1):
            print ".".repeat(currBlock.endInd - currBlock.startInd) & " "
        else:
            print intToStr(currBlock.id).repeat(currBlock.endInd - currBlock.startInd) & " "
    echo ""

var id = 0
var currInd = 0

var diskMap: seq[Block] = @[]

for i, c in fileContent:
    let v = int(c) - int('0')
    if i mod 2 == 0:
        let theBlock = (id: id, startInd: currInd, endInd: currInd+v)
        diskMap.add(theBlock)
        id += 1
    else:
        let theBlock = (id: -1, startInd: currInd, endInd: currInd+v)
        diskMap.add(theBlock)

    currInd += v

iterator getFileBlocks(diskMap: seq[Block]): int =
    for i,currBlock in reversed(diskMap):
        if currBlock.id != -1:
            yield diskMap.len - i - 1

proc findNextFreeSpace(diskMap: var seq[Block], fileBlockInd: int): bool =
    let fileBlock = diskMap[fileBlockInd]
    for i,currBlock in diskMap[0..^1]:
        if (currBlock.id != -1):
            continue

        var freeSpace = currBlock
        if (fileBlock.startInd < freeSpace.startInd):
            continue

        let fileL = (fileBlock.endInd - fileBlock.startInd)
        let freeL = (freeSpace.endInd - freeSpace.startInd)

        if (fileL <= freeL):
            diskMap[fileBlockInd] = (-1, fileBlock.startInd, fileBlock.endInd)
            diskMap[i] = (fileBlock.id, freeSpace.startInd, freeSpace.startInd + fileL)
            if (freeSpace.startInd + fileL <= freeSpace.endInd):
                diskMap.insert((-1, freeSpace.startInd + fileL, freeSpace.endInd), i+1)
            return true
    return false

var valid = true
while valid:
    valid = false
    for fileBlockInd in getFileBlocks(diskMap):
        if (findNextFreeSpace(diskMap, fileBlockInd)):
            valid = true
            break

var sum = 0
for i,currBlock in diskMap:
    if (currBlock.id == -1):
        continue
    # echo currBlock
    let a1 = currBlock.startInd
    let an = currBlock.endInd-1
    let n = an - a1 + 1

    sum += ((n*(a1+an)) div 2) * currBlock.id
echo sum




    



            

