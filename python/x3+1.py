#!/usr/bin/env python

import sys
#print "This is the name of the script: ", sys.argv[0]
#print "Number of arguments: ", len(sys.argv)
#print "The arguments are: " , str(sys.argv)

if len(sys.argv) != 2:
    print "Usage %s n" % sys.argv[0]
    exit(1)

def next(n):
    if n%2==1:
        n = 3*n+1
    while n%2==0:
        n = n/2
    return n


i=int(sys.argv[1])

while i > 1:
    print "%-10d%s" % (i, "{0:16b}".format(i))
    i = next(i)
