#!/usr/bin/env python

import sys
#print "This is the name of the script: ", sys.argv[0]
#print "Number of arguments: ", len(sys.argv)
#print "The arguments are: " , str(sys.argv)

if len(sys.argv) != 2:
  print "Usage %s n" % sys.argv[0]
  exit(1)

def q(n,s):
    print "q(%d, %d)" % (n,s)
    if n == s:
        return 1
    if n < s:
        return 0
    a = 0
    for i in range(s,n-s+1):
        a += q(n-s,i)
    return a

def p(n):
    print "p(%d)" % (n)
    global p_mem
    if n==1:
        p_mem[1] = 1;
        return 1
    if p_mem[n]:
        return p_mem[n]
    a = 1; # One to count for n = just n
    for i in range(1,n+1):
        a += q(n-1,i)
    p_mem[n] = a
    return a

i=int(sys.argv[1])

p_mem = [0] * (i+1)
print "p(%d) = %d" % (i, p(i))
