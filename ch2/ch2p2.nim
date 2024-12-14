import macros
import sequtils
import std/os
import std/strutils
import std/algorithm

func check(reactor: seq[int]): int =
    var safe = true

    let increasingI = (reactor[1] - reactor[0]) > 0;
    let safeI = abs(reactor[1] - reactor[0]);
    safe = safeI >= 1 and safeI <= 3
    if (not safe):
        return 0

    for i in 2..<reactor.len:
        let increasingV = (reactor[i] - reactor[i-1]) > 0;
        let safeV = abs(reactor[i] - reactor[i-1]);

        if (increasingV != increasingI or safeV > 3 or safeV < 1):
            return i
    
    if (safe):
        return -1

proc tryMe(reactor: seq[int], i: int): bool =
    if (i < 0 or i >= reactor.len):
        return false

    var newReactor = reactor
    newReactor.delete(i)
    let safe = check(newReactor)
    if (safe == -1):
        return true
    return false


let fileContent = readFile(paramStr(1));

var safeReports = 0
for line in splitLines(fileContent):
    if (line.len <= 0):
        break

    var reactor = splitWhitespace(line).mapIt(parseInt(it))

    var safe = check(reactor)
    if (safe == -1):
        safeReports += 1
    else:
        for i in 0..<reactor.len:
            if (tryMe(reactor, i)):
                safeReports += 1
                break
    
echo(safeReports)