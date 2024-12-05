import std/os
import std/nre
import std/sequtils
import std/strutils

let fileContent = readFile(paramStr(1));
var xmasArray = splitLines(fileContent)

proc findXmas(xmasArray: seq[string]): int =
    var sum = 0;
    for line in xmasArray:
        sum += count(line, "XMAS", true)
        sum += count(line, "SAMX", true)
    return sum

proc transpose(M: seq[string]): seq[string] =
    var newM = toSeq(0..<M[0].len).mapIt(" ".repeat(M.len));

    for i in 0..<M.len:
        for j in 0..<M[0].len:
            newM[j][i] = M[i][j]
    return newM

proc shear(M: seq[string], negative: bool = false): seq[string] =
    var newM = toSeq(0..<M.len).mapIt(M[it]);
    for i in 0..<M.len:
        let a = (if negative: M.len-1-i else: i)
        newM[a] = " ".repeat(i) & newM[a] & " ".repeat(M.len-i-1)
    return newM


let xmasArrayT = transpose(xmasArray)
let xmasArrayS = shear(xmasArray)
let xmasArrayNS = shear(xmasArray, true)

let xmasArrayST = transpose(xmasArrayS)
let xmasArrayNST = transpose(xmasArrayNS)

var sum = 0;
sum += findXmas(xmasArray)
sum += findXmas(xmasArrayT)
# sum += findXmas(xmasArrayS)
# sum += findXmas(xmasArrayNS)
sum += findXmas(xmasArrayST)
sum += findXmas(xmasArrayNST)

echo sum