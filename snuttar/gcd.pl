#!/usr/bin/perl

my $a = shift @ARGV;
my $b = shift @ARGV;

sub gcd
{
  my $x = shift;
  my $y = shift;

  return &gcd($y, $x) if ($x < $y);
  return $x if ($y == 0);
  return &gcd($x-$y, $y);
}

print "gcd($a, $b) = ", &gcd($a, $b), "\n";
