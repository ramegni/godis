#!/usr/bin/env python

from __future__ import print_function
import sys
import math

if len(sys.argv) != 2:
    print("Usage: %s value" % (sys.argv[0]))
    exit(1)

v = float(sys.argv[1])
a = 1
b = 1
last_error = 1

q = 1.0*a/b
while (True):
    if q<v:
        a = a+1
    else:
        b = b+1
    q = 1.0*a/b
    error = abs(q-v)
    if error < last_error:
        print("%d/%d = %f  error = %f error_log %f" % (a,b,q,error,math.log(error)))
        last_error = error
        if error == 0:
            exit(1)
        x = raw_input('?')
