#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use File::Slurp;
open my $fh,'<','colonylist.txt';
my $current_empire='';
my $first_present=0;
while (my $line=<$fh>) {
  $line=~s/\s+$//s;
  if ($line=~/^\s*\d+\.\s*(\w.*[\w\)])$/s) {
    $current_empire=$1;
    #say "$current_empire";
    $first_present=0;
  } elsif ($line=~/(-?\d+)x? , \s* (-?\d+)y?/sx) {
    next if $first_present;
    $first_present=1;
    my ($x,$y)=($1,$2);
    #say "$x,$y - $line";
    say "$x,$y - $current_empire";
    
  }
}
