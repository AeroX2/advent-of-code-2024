import std/os
import std/strutils
import std/algorithm

let fileContent = readFile(paramStr(1));

var id = 0
var diskMap: seq[int] = @[]
for i, c in fileContent:
    let v = int(c) - int('0')
    if i mod 2 == 0:
        for _ in 0..<v:
            diskMap.add(id)
        id += 1
    else:
        for _ in 0..<v:
            diskMap.add(-1)

var freeSpaces: seq[int] = @[]
var fileBlocks: seq[(int, int)] = @[]
for i, c in diskMap:
    if c == -1:
        freeSpaces.add(i)
    else:
        fileBlocks.add((c, i))
freeSpaces = freeSpaces.reversed

# echo freeSpaces
# echo fileBlocks

var freeSpaceInd = freeSpaces.pop()
var (fileId, fileBlockInd) = fileBlocks.pop()
var finalDiskMap = diskMap
while freeSpaceInd <= fileBlockInd:
    finalDiskMap[freeSpaceInd] = fileId
    finalDiskMap[fileBlockInd] = -1
    # freeSpaces.insert(fileBlockInd, 0)

    if (freeSpaces.len <= 0 or fileBlocks.len <= 0):
        break
    freeSpaceInd = freeSpaces.pop()
    (fileId, fileBlockInd) = fileBlocks.pop()

# echo finalDiskMap
var sum = 0
for i, c in finalDiskMap:
    if (c == -1):
        continue
    sum += i*c
echo sum

