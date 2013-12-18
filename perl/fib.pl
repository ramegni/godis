$c = 0;
sub fib {
  my $n = shift;
  $c++;
  #print "fib($n)\n";
  return 1 if ($n < 3);
  return (fib($n-1) + fib($n-2));
}

$i=shift;

print "fib($i) = ",fib($i), "\n";
print "fib called $c times\n";
