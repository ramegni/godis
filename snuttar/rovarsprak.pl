@vokals = qw(a e i o u y å ä ö);
foreach (@vokals) {
  $is_vokal{$_} = 1;
  $is_vokal{uc($_)} = 1;
}

while (<>) {
  foreach (split //, $_) {
    if (/\w/) {
      if ($is_vokal{$_}) {
	print $_;
      } else {
	print $_, "o", $_;
      }
    } else {
      print $_;
    }
  }
}
