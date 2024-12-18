import std/math
import std/strutils

for v in @[2,4,1,3,7,5,1,5,0,3,4,3,5,5,3,0]:
  for a in 0b1000000..0b1111111:
    let b = a mod 8
    let b1 = b xor 3
    let c = a div (2 ^ b1)
    let b2 = b1 xor 5
    if ((c xor b2) == v):
      echo a.toBin(7)
  echo ""
