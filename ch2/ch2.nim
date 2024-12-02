import macros
import sequtils
import std/os
import std/strutils
import std/algorithm

let fileContent = readFile(paramStr(1));

var safeReports = 0
for line in splitLines(fileContent):
    if (line.len <= 0):
        break

    let reactor = splitWhitespace(line).mapIt(parseInt(it))
    var safe = true

    let increasingI = (reactor[1] - reactor[0]) > 0;
    let safeI = abs(reactor[1] - reactor[0]);
    safe = safeI >= 1 and safeI <= 3

    for i in 2..<reactor.len:
        let increasingV = (reactor[i] - reactor[i-1]) > 0;
        let safeV = abs(reactor[i] - reactor[i-1]);

        if (increasingV != increasingI or safeV > 3 or safeV < 1):
            safe = false
            break
    
    if (safe):
       safeReports += 1
        

        
echo(safeReports)