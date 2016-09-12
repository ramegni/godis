
use strict;
use warnings;

sub sieve
{
  my $first = shift;
  my @list;
  #print "first = $first  \@_ = @_\n";
  @list = grep {$_ % $first != 0} @_;
  #print "first = $first  list = @list\n";
  return ($first) if (@list == 0);
  return ($first, &sieve(@list));
}

my @primes = &sieve(2..100);

print "@primes\n";
