#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

my $max_radius_of_cluster=100;
my $diam=2*$max_radius_of_cluster;
say "max radius: $max_radius_of_cluster, diameter: $diam";

use Algorithm::ClusterPoints;
my $clp = Algorithm::ClusterPoints->new(radius => $max_radius_of_cluster, minimum_size => 1, ordered => 1, dimension => 2);

open my $fh,'<','colonylist.txt';
my $current_empire='';
my $first_present=0;
my %coord2empire;
while (my $line=<$fh>) {
  $line=~s/\s+$//s;
  if ($line=~/^\s*\d+\.\s*(\w.*[\w\)])$/s) {
    $current_empire=$1;
    $current_empire=~s/\(.*?\)//;
    $current_empire=~s/\s+$//s;
    #say "$current_empire";
    $first_present=0;
  } elsif ($line=~/(-?\d+)x? , \s* (-?\d+)y?/sx) {
    next if $first_present;
    $first_present=1;
    my ($x,$y)=($1,$2);
    #say "$x,$y - $line";
    #say "$x,$y - $current_empire";
    $coord2empire{"$x, $y"}=$current_empire;
    $clp->add_point($x,$y);
  }
}
my @clusters = $clp->clusters_ix;

#print Data::Dumper->Dump([\@clusters_ix], ['clusters_ix']);
  for my $i (0..$#clusters) {
      print( join( ' ',
                   "cluster $i:",
                   map {
                       my ($x, $y) = $clp->point_coords($_);
                       my $empire=$coord2empire{"$x, $y"};
                       "('$empire': $x, $y)"
                   } @{$clusters[$i]}
                 ), "\n"
           );
  }
