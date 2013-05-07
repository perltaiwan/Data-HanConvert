#!/usr/bin/env perl
use strict;
binmode STDOUT, ":utf8";

use YAML;

sub char {
    chr hex($_[0]||$_)
}

my %ambigious_character;

# Assume the input is Unihan_Variants.txt
while(<>) {
    my ($type) = m!(k\S+)!;
    next unless $type eq 'kTraditionalVariant' || $type eq 'kSimplifiedVariant';

     my ($x, @y) = m! U\+([0-9A-F]+) !xg;

     if (@y > 1) {
         $x = char($x);
         @y = map char, @y;

         $ambigious_character{$type}{$x} = \@y;
     }
 }

for my $type (keys %ambigious_character) {
    print "\n# $type\n";
    while(my ($k,$v) = each %{$ambigious_character{$type}}) {
        print $k,": ",@$v,"\n";
    }
}
