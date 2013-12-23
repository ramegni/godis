#!perl
#
# Set xterm window title

$title = join(" ", @ARGV);
print "\033]0;$title\007";
