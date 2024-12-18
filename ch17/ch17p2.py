# Tried the Nim z3 bindings, but the examples didn't eeven work
# Some bug in the actual implementation
# z3-0.1.4-22f53a6b81c0a2988b34ecc970b9d4b9ab185622/z3.nim(295, 58) Error: type mismatch: got 'typeof(nil)' for 'nil' but expected 'Z3_sort = distinct pointer'

from z3 import *

solver = z3.Optimize()
v = [2, 4, 1, 3, 7, 5, 1, 5, 0, 3, 4, 3, 5, 5, 3, 0]

bit_width = 3 * len(v) + 4
a = BitVec("a", bit_width)
pa = a

for x in v:
    b = a & 0b111
    b2 = b ^ 3
    c = LShR(a, b2)
    b3 = b2 ^ 5
    solver.add(((b3 ^ c) & 0b111) == x)
    a = LShR(a, 3)

solver.minimize(pa)
if solver.check() == z3.sat:
    print(solver.model()[pa])
else:
    print("No solution found")