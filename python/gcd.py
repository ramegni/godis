#!/usr/bin/env python3

# Greatest Common Divisor

import sys
import math

if len(sys.argv) != 3:
    print("Usage: %s number number" % (sys.argv[0]))
    exit(1)

n = abs(int(sys.argv[1]))
m = abs(int(sys.argv[2]))

#print( "n=%d, m=%d" % (n,m))
while m != n:
    if n>m:
        x = m
        m = n
        n = x
    d = m-n
#    print("%d - %d = %d" % (m,n,d))
    m = n
    n = d

print("GCD = %d" % (d))
