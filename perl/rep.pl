#!/usr/atria/bin/Perl

# Repeat command and print if output changes.
# Default delay is 10 seconds unless given by -d flag.
#

$delay = 10;
if ($ARGV[0] eq "-d") {
  shift;
  $delay = shift;
}
print "delay = $delay\n";

$cmd = join ' ', @ARGV;
$old_output = "";

while (1) {
  $output = `$cmd`;
  if ($output ne $old_output) {
    print "------------------------------------\n";
    print $output;
    $old_output = $output;
  }
  sleep($delay);
}
