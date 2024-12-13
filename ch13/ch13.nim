import std/os
import std/nre
import std/math
import std/strutils
import std/sequtils

# Math was never my strong suit, borrowed from ChatGPT,
# have to say though ChatGPT sucks at Nim

# Function to calculate the determinant of a matrix
proc determinant(matrix: seq[seq[float]]): float =
  let n = matrix.len
  if n == 1:
    return matrix[0][0]
  elif n == 2:
    return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
  else:
    var det = 0.0
    for i in 0..<n:
      var subMatrix = newSeq[seq[float]](n - 1)
      for row in 1..<n:
        subMatrix[row - 1] = newSeq[float](n - 1)
        for col in 0..<n:
          if col != i:
            subMatrix[row - 1].add(matrix[row][col])
      det += matrix[0][i] * determinant(subMatrix) * (if i mod 2 == 0: 1 else: -1)
    return det

# Replace a column in a matrix
proc replaceColumn(matrix: seq[seq[float]], column: seq[float], colIdx: int): seq[seq[float]] =
  result = matrix.deepCopy()
  for i in 0..<matrix.len:
    result[i][colIdx] = column[i]

# Solve a system of linear equations using Cramer's Rule
proc cramerSolver(coefficients: seq[seq[float]], constants: seq[float]): seq[float] =
  let detA = determinant(coefficients)
  if detA == 0.0:
    raise newException(ValueError, "The determinant of the coefficient matrix is zero, no unique solution exists.")
  
  var solutions = newSeq[float](coefficients.len)
  for i in 0..<coefficients.len:
    let modifiedMatrix = replaceColumn(coefficients, constants, i)
    solutions[i] = determinant(modifiedMatrix) / detA
  return solutions

let fileContent = readFile(paramStr(1));
let clawMachine = split(fileContent, "\n\n").mapIt(splitLines(it))

var tokens = 0.0
for lines in clawMachine:
    let mButtonA = lines[0].match(re"Button A: X\+([0-9]+), Y\+([0-9]+)").get
    let mButtonB = lines[1].match(re"Button B: X\+([0-9]+), Y\+([0-9]+)").get
    let mPrize = lines[2].match(re"Prize: X=([0-9]+), Y=([0-9]+)").get

    let coefficients = @[
        @[
            parseFloat(mButtonA.captures[0]),
            parseFloat(mButtonB.captures[0])
        ],
        @[
            parseFloat(mButtonA.captures[1]),
            parseFloat(mButtonB.captures[1])
        ],
    ]
    let constants = @[
        parseFloat(mPrize.captures[0]),
        parseFloat(mPrize.captures[1]),
    ]

    let s = cramerSolver(coefficients, constants)
    if (almostEqual(floor(s[0]), s[0]) and
        almostEqual(floor(s[1]), s[1])):
        tokens += s[0]*3 + s[1]
echo tokens