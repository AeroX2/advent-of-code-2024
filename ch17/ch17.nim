import std/os
import std/math
import std/strutils
import std/sequtils

type Registers* = object
  a: int
  b: int
  c: int

let fileContent = readFile(paramStr(1));
let lines = splitLines(fileContent)

var pc = 0
var registers = Registers(a: 0, b: 0, c: 0)
registers.a = parseInt(lines[0].split(": ")[1])
registers.b = parseInt(lines[1].split(": ")[1])
registers.c = parseInt(lines[2].split(": ")[1])

let instructions = lines[4].split(": ")[1].split(",").mapIt(parseInt(it))

proc getValue(opCom: int): int =
  case (opCom):
    of 0:
      return 0
    of 1:
      return 1
    of 2:
      return 2
    of 3:
      return 3
    of 4:
      return registers.a
    of 5:
      return registers.b
    of 6:
      return registers.c
    else:
      raise newException(ValueError, "This op combo doesn't exist")

proc processOp(op: int, opCom: int) = 
  # echo "Op: ", op
  # echo "Op com: ", opCom

  case (op):
    of 0: # adv
      registers.a = registers.a div (2 ^ getValue(opCom))
    of 1: # bxl
      registers.b = registers.b xor opCom
    of 2: # bst
      registers.b = getValue(opCom) mod 8
    of 3: # jnz
      if (registers.a != 0):
        pc = opCom - 2
    of 4: # bxc
      registers.b = registers.b xor registers.c
    of 5: # out
      stdout.write (getValue(opCom) mod 8) 
      stdout.write ","
    of 6: # bdv
      registers.b = registers.a div (2 ^ getValue(opCom))
    of 7: # cdv
      registers.c = registers.a div (2 ^ getValue(opCom))
    else:
      raise newException(ValueError, "Wat")

while pc <= instructions.len-2:
  let op = instructions[pc]
  let opCom = instructions[pc+1]
  processOp(op, opCom)
  pc += 2


