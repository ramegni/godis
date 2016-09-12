#!/usr/bin/perl

use sigtrap 'handler', \&my_handler, 'normal-signals';


sub my_handler
{
  my $sig = shift;
  print "recieved signal $sig\n";
  return;
}

sleep 60;
print "Normal exit\n";
