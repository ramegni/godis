#!/usr/bin/env python

import sys
import itertools

"""
Try all combinations of four numbers and the binary functions listed in funcs
to get the given result.

A tuff one is 1 3 4 6 giving 24.
The uniq answer is
6/(1-3/4)
"""

funcs = ['+', '-', '*', '/']

func_dict = {
    '+' : float.__add__,
    '-' : float.__sub__,
    '*' : float.__mul__,
    '/' : float.__div__,
    }

def eval_RPN(li):
    l = li[:]
    s = []
    while (l):
        a = l.pop(0)
        if a in func_dict:
            try:
                b = func_dict[a](s[0],s[1])
            except ZeroDivisionError:
                return(0)
            s.pop(0)
            s.pop(0)
            s.insert(0,b)
        else:
            s.insert(0,a)
    return(s[0])

print sys.argv

if len(sys.argv) != 6:
     print 'Usage: fyra_nummer.py t1 t2 t3 t4 summa'
     exit(1)

result = int(sys.argv[5])
t = map(float, sys.argv[1:5])

#print result+sum(t)

#rp = [1,2,'+']
#x = eval_RPN(rp)
#print rp, '=', x

#rp = [1,2,'+',3,'*', 100, '+']
#x = eval_RPN(rp)
#print rp, '=', x

#rp = [0,2,3,1,'*', '*', '/']
#x = eval_RPN(rp)
#print rp, '=', x

for (a,b,c,d) in itertools.permutations(t):
    # Pattern  ab?c?d? = ((a?b)?c)?d
    for i in funcs:
        for j in funcs:
            for k in funcs:
                try:
                    r = func_dict[k](func_dict[j](func_dict[i](a,b),c),d)
                except ZeroDivisionError:
                    r = 0
                #except TypeError:
                #    r = -1
                #print 'r = ', r
                if r == result:
                    print '((%d%s%d)%s%d)%s%d = %d' % (a,i,b,j,c,k,d,r)

    # Pattern  ab?cd?? = (a?b)?(c?d)
    for i in funcs:
        for j in funcs:
            for k in funcs:
                try:
                    r = func_dict[j](func_dict[i](a,b),func_dict[k](c,d))
                except ZeroDivisionError:
                    r = 0
                except TypeError:
                    r = -1
                if r == result:
                    print '(%d%s%d)%s(%d%s%d) = %d' % (a,i,b,j,c,k,d,r)

    # Pattern  abc?d?? = a?((b?c)?d)
    for i in funcs:
        for j in funcs:
            for k in funcs:
                try:
                    r = func_dict[i](a,func_dict[k](func_dict[j](b,c),d))
                except ZeroDivisionError:
                    r = 0
                except TypeError:
                    r = -1
                if r == result:
                    print '%d%s((%d%s%d)%s%d) = %d' % (a,i,b,j,c,k,d,r)

    # Pattern  abc??d? = (a?(b?c))?d
    for i in funcs:
        for j in funcs:
            for k in funcs:
                try:
                    r = func_dict[k](func_dict[i](a,func_dict[j](b,c)),d)
                except ZeroDivisionError:
                    r = 0
                except TypeError:
                    r = -1
                if r == result:
                    print '(%d%s(%d%s%d))%s%d = %d' % (a,i,b,j,c,k,d,r)

    # Pattern  abcd??? = a?(b?(c?d))
    for i in funcs:
        for j in funcs:
            for k in funcs:
                try:
                    r = func_dict[i](a,func_dict[j](b, func_dict[k](c,d)))
                except ZeroDivisionError:
                    r = 0
                except TypeError:
                    r = -1
                if r == result:
                    print '%d%s((%d%s(%d%s%d)) = %d' % (a,i,b,j,c,k,d,r)
