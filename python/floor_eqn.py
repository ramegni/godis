#!/usr/bin/env python3

# Solve equation
# floor(x+1/27) + ... + floor(x+80/27) = 500

import sys
import math

if len(sys.argv) != 2:
    print("Usage: %s x-value" % (sys.argv[0]))
    exit(1)

#x = 3.999999999
x = float(sys.argv[1])
s = 0
for i in range(1,81):
    t = math.floor(x+i/27)
    s += t
    print("i = %d floor(%f + %d/27) = %d sum = %d" % (i,x,i,t,s))
