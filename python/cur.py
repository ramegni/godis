#!/usr/bin/env python

import sys
import curses
#print "This is the name of the script: ", sys.argv[0]
#print "Number of arguments: ", len(sys.argv)
#print "The arguments are: " , str(sys.argv)

if len(sys.argv) != 2:
  print "Usage %s n" % sys.argv[0]
  exit(1)

i=int(sys.argv[1])

stdscr = curses.initscr()

pad = curses.newpad(100, 100)
# These loops fill the pad with letters; this is explained in the next section
for y in range(0, 100):
    for x in range(0, 100):
        try:
            pad.addch(y,x, ord('a') + (x*x+y*y) % 26)
        except curses.error:
            pass

#  Displays a section of the pad in the middle of the screen
pad.refresh(0,0, 5,5, 20,75)
