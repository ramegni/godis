#!/usr/bin/perl

$n = shift @ARGV;

for ($i=0; $i<$n; $i++) {
  $values[$i] = $i+1;
}

$total_count = 0;
$correct_place = 0;

&perm(0);

print "correct_place = $correct_place\n";
print "total_count   = $total_count\n";

sub perm 
{
  my $i = shift;
  if ($i == $n-1) {
    print @values, "\n";
    $total_count++;
    my $d;
    for ($d=0; $d<$n; $d++) {
      if ($values[$d] == $d+1) {
	$correct_place++;
	last;
      }
    }
    return;
  }
  &perm($i+1);
  my $j;
  my $tmp;
  for ($j=$i+1; $j<$n; $j++) {
    $tmp = $values[$j];
    $values[$j] = $values[$i];
    $values[$i] = $tmp;
    &perm($i+1);
    $tmp = $values[$j];
    $values[$j] = $values[$i];
    $values[$i] = $tmp;
  }
  return;
}

