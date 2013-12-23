#!/usr/bin/perl

use Getopt::Long;
use IO::File;
use strict "vars";

$|=1;
use vars qw(
 %argv %input $usage $result
 @files @dirs
 %file $lastfile
 $allwaysseekzero %previous
 %signaled %colors
 $lastuniq
);


sub handle_signals {
  my($sig) = @_;
  $signaled{$sig}++;
  print "\n*** Caught $sig\n";
}

$SIG{"USR1"} = "handle_signals";

%input=( "s|sleep" => "sleep time in seconds between rounds",
 "n|nomodify" => "don't actually delete anything - just print steps taken",
 "v|verbose" => "spew extra data to the screen",
 "ansi" => "do some highlighting",
 "f|follow" => "compatibility flag.  we ALWAS follow.",
 "error=s\@" => "treat this as an error for ansi highlighting",
 "warning=s\@" => "treat this as an error for ansi highlighting",
 "notice=s\@" => "treat this as an error for ansi highlighting",
 "stats=s\@" => "treat this as an error for ansi highlighting",
 "uniq" => "only show unique lines",
 "label" => "label every line",
 "i" => "grep = case sensitive",
 "grep|grepor=s\@" => "only show lines that match at least one of these patterns",
 "grepand=s\@" => "only show lines that match all of these patterns",
 "grepnot=s\@" => "omit lines that match at least one of these patterns",
 "onlyfiles=s" => "when scanning directories, only include files that match this pattern",
 "h|help" => "show option help");


$result = GetOptions(\%argv,keys %input);
$argv{"v"} ||= $argv{"n"};
$argv{"s"} ||= 1;

$colors{"banner"} = "\e[0;1m";
$colors{"plain"} = "\e[0m";
$colors{"warning"} = "\e[0;31m";
$colors{"notice"} = "\e[0;1;32m";
$colors{"stats"} = "\e[0;1;33m";
$colors{"error"} = "\e[0;1;31m";
%colors = map{$_=>""} keys %colors if (!$argv{"ansi"});


push(@ {$argv{"error"}}, "(?i)error") unless (scalar(@ {$argv{"error"}}));
push(@ {$argv{"warning"}}, "(?i)warning") unless (scalar(@ {$argv{"warning"}}));
push(@ {$argv{"notice"}}, "(?i)notice") unless (scalar(@ {$argv{"notice"}}));
push(@ {$argv{"stats"}}, "(?i)stats") unless (scalar(@ {$argv{"stats"}}));
generate_color_filter();
generate_grep_filter();


if ((!$result) || (! scalar @ARGV) || ($argv{h})) {
   &showOptionsHelp; exit 0;
}

addfiles(grep(-f,@ARGV));      # Plain files
addfiles(grep(! -e , @ARGV));  # Non existent files might show up later
@dirs  = grep(-d,@ARGV);       # List of directories we need to scan



while(1) {
  if ($signaled{"USR1"}) {
    $signaled{"USR1"}=0;
    banner("Files open:");
    foreach my $file (sort keys %file) {
      print "  $file  ";
      if ($file{$file}) {
        my $tell = tell($file{$file});
        my $modified = scalar localtime ((stat($file{$file}))[8]);
        print "($tell bytes, modified $modified)\n";
      } else {
        print "(not open yet)\n";
      }
    }
   print "\n";
  }

  scandirs(@dirs);


  foreach my $file (sort keys %file) {
    # Check to see if we need to open it
    openfile($file) if (! defined $file{$file});
    next if (! defined $file{$file});
    
    # Check to see if the file has changed
    my $oldino = (stat($file{$file}))[1];
    my $newino = (stat($file))[1];
    if ($oldino != $newino) {
      banner("File $file changed") unless ($argv{"label"});
      close($file{$file});
      openfile($file);   
      seek($file,0,SEEK_SET);
    }
    my $tell = tell($file{$file});
    my $size = -s $file;
    if ($size < $tell) {
      banner("File $file truncated (size=$size, tell=$tell)") unless ($argv{"label"});
      close($file{$file});
      $file{$file} = new IO::File "<$file";
      seek($file,0,SEEK_SET);
    
    }
    if ($size != $tell) {
      my $handle = $file{$file};
      my $goback = tell($file{$file});
      while(my $line = <$handle>) {
        if ($line =~ m#\n$#) {
          $goback += length($line);
          chomp $line;
	  next  unless (grep_filter($line));
          if ($argv{"uniq"}) {
               next if ($lastuniq eq $line);
               $lastuniq = $line;
          }
          unless($file eq $lastfile) {
            banner("File: $file") unless ($argv{"label"});
            $lastfile = $file;
          }
          print "$file\: " if ($argv{"label"});
          print color_filter($line) . "\n";
        } else {
          seek($handle,$goback,SEEK_SET);
          last;
        }
      }
      seek($handle,0,SEEK_CUR); # Reset EOF status
    }

  }
  sleep $argv{"s"};
# Hmm. I don't like this - when files get rotated, we see the entire old file:  $allwaysseekzero = 1;  # Any new files after this point, show all data from offset zero
}

sub addfiles {
  foreach (@_) {
   next if (defined $file{$_});
   openfile($_);
  }
}

# Actually open the file, seek to the end
sub openfile {
  my($file) = @_;
  my $reopen = (defined $previous{$file});
  return if (-B $file);  # This may need optimization

  close($file{$file}) if ($reopen);

  $file{$file} = new IO::File  "<$file";
  if (defined $file{$file}) {
    $previous{$file}=1;
    seek($file{$file},0,SEEK_END) unless (($reopen) || ($allwaysseekzero));
  }
}


sub scandirs {
  my(@dirs) = @_;
  foreach my $dir (@dirs) {
    $dir =~ s#/$##;
    opendir(DIR,$dir);
    while(my $f = readdir DIR) {
      if ($argv{"onlyfiles"}) {
        next unless ($f =~ m#$argv{onlyfiles}#);
      }
      addfiles("$dir/$f");
    }
    closedir DIR;
  }
}





sub showOptionsHelp {
 my($left,$right,$a,$b,$key);
 my(@array);
 print "Usage: $0 [options] $usage\n";
 print "where options can be:\n";
 foreach $key (sort keys (%input)) {
    ($left,$right) = split(/[=:]/,$key);
    ($a,$b) = split(/\|/,$left);
    if ($b) {  
      $left = "-$a --$b";
    } else {
      $left = "   --$a";
    }
    $left = substr("$left" . (' 'x20),0,20);
    push(@array,"$left $input{$key}\n");
 }
 print sort @array;
}


sub banner {
  my($b) = @_;
  print "\n$colors{banner}*** $b $colors{plain}\n";
}

sub generate_color_filter {
  my $perl;
  foreach my $type ("stats","notice","warning","error") {
    foreach ( @ {$argv{$type}} ) {
      my $color;
       $color = $colors{$type};
       $perl .= <<"EOF";
       \$color = '$color' if (\$line =~ m#$_#o);
EOF
    }
  }

  my $code = <<'EOF';
sub color_filter {
  my ($line) = @_;
  my $color;
  $perl
  if ($color) {
    return $color . $line . $colors{'plain'};
  } else {
    return $line;
  }
}
EOF

  $code =~ s/\$perl/$perl/g;
  eval $code;
  die if ($@);
}


sub generate_grep_filter {
  my $perl;

  if ((! defined $argv{"grep"}) && (! defined $argv{"grepnot"}) && (! defined $argv{"grepand"})) {
     $perl = <<'EOF';
sub grep_filter {
  return 1;
}
EOF
     eval $perl;
     die if ($@);
     return;
  }


  if (defined  $argv{"grepnot"}) {
      foreach my $re (@ {$argv{"grepnot"}})  {
        $perl .= <<"EOF";
          return 0 if (/$re/i); # grepnot
EOF
      }
  }
 
  if (defined $argv{"grepand"}) {
      foreach my $re (@ {$argv{"grepand"}})  {
        $perl .= <<"EOF";
          return 0 unless (/$re/i); # grepand
EOF
      }
  }
  if (defined $argv{"grep"}) {
      foreach my $re (@ {$argv{"grep"}})  {
        $perl .= <<"EOF";
          return 1 if (/$re/i); # grep
EOF
      }
  }


  unless (defined $argv{"i"}) {
      $perl =~ s#/i\); \##/\); \##g;
  }

  if (defined $argv{'grep'}) {
    $perl .= <<"EOF";
       return 0;   # grep specified
EOF
  } else { 
    $perl .= <<"EOF";
       return 1;   # grep not specified.
EOF
  }


print "perl=\n$perl\n" if ($argv{'v'});

  my $code = <<'EOF';
sub grep_filter {
  $_ = shift @_;
  $perl
}
EOF

  $code =~ s/\$perl/$perl/g;
  eval $code;
  die if ($@);
}
