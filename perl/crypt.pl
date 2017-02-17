#!/usr/bin/perl -w

# Encrypt/decrypt a file using the famous Ingemar Assarsjö encryption algorithm

@dec2hex = qw(0 1 2 3 4 5 6 7 8 9 A B C D E F);

sub error_pause
{
  $err = shift @_;
  print STDERR "$err\n";
  print STDERR "\nPress enter\n";
  <>;
  exit 1;
}

sub ia_encrypt
{
  ($infile, $outfile) = @_;

  open IN_FILE, $infile;
  open OUT_FILE, ">$outfile";
  binmode IN_FILE;
  binmode OUT_FILE;

  $index = 0;

  while (defined ($c = getc(IN_FILE))) {
    $x = ord($c) ^ $password_list[$index % $passwd_len];
    $x1 = $dec2hex[$x>>4];
    $x2 = $dec2hex[$x&15];
    print OUT_FILE $x1, $x2;
    $index++;
    # Put in newlines to beutify encrypted file
    print OUT_FILE "\n" if ($index % 32 == 0);
  }

  close IN_FILE;
  close OUT_FILE;
}

sub ia_decrypt
{
  ($infile, $outfile) = @_;

  open IN_FILE, $infile;
  open OUT_FILE, ">$outfile";
  binmode IN_FILE;
  binmode OUT_FILE;

  $index = 0;
  while (defined ($c = getc(IN_FILE))) {
    # Skip newlines
    next if ($c eq "\n");
    $c2 = getc(IN_FILE);
    $c = hex($c)*16 + hex($c2);
    $x = $c ^ $password_list[$index % $passwd_len];
    print OUT_FILE chr($x);
    $index++;
  }

  close IN_FILE;
  close OUT_FILE;
}


if (@ARGV != 1) {
  error_pause "Usage: crypt.pl <file name>";
}

$file = shift;

if (! -f $file) {
  error_pause "$file: No such file.";
}

use Term::ReadKey;
print "Password: ";
ReadMode('noecho'); # don't echo
$passwd = <>;
chomp $passwd;
ReadMode(0);        # back to normal

exit 1 if ($passwd eq "");

$passwd_len = length $passwd;
@password_list = split //, $passwd;
@password_list = map(ord, @password_list);

$tmp_file = $file . ".txt";

ia_decrypt($file, $tmp_file);

system("vi $tmp_file");

rename ($file, "$file" . ".bck");

ia_encrypt($tmp_file, $file);

unlink($tmp_file);
