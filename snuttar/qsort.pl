#!/usr/bin/perl

use warnings;
use strict;


sub qsort
{
  my @l = @_;
  print "qsort(@l)\n";
  return @l if (@l <= 1);
  my $e = shift @l;
  my @l1 = ();
  my @l2 = ();
  foreach (@l) {
    if ($_ < $e) {
      push @l1, $_;
    } else {
      push @l2, $_;
    }
  }
  print "qsort: e = $e\n";
  print "qsort: l1 = @l1\n";
  print "qsort: l2 = @l2\n";
  return (&qsort(@l1), $e, &qsort(@l2));
}

my @list = <>;
chomp @list;

@list = &qsort(@list);
print "@list\n";
