#!/usr/bin/python

import sys
#print "This is the name of the script: ", sys.argv[0]
#print "Number of arguments: ", len(sys.argv)
#print "The arguments are: " , str(sys.argv)

if len(sys.argv) != 2:
  print "Usage %s n" % sys.argv[0]
  exit(1)

def fib(n):
  if n<=2:
    return 1
  return fib(n-1) + fib(n-2)

i=int(sys.argv[1])

print "fib(%d) = %d" % (i, fib(i))
