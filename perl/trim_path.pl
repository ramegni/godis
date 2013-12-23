#!perl

foreach $i (split ':' , $ARGV[0]) {
  $found=0;
  foreach $x (@newpath) {
    if ($i eq $x) {
      $found = 1;
    }
  }
  if (!$found) {
    push @newpath, $i;
  }
}
print join(':', @newpath);
