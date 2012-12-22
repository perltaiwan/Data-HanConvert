#!/usr/bin/env perl
#
# Assuming the given @ARGV contains text files that contains
# no characters from Simplified Chinese.
#

use strict;
use encoding 'utf8';
use List::MoreUtils qw(uniq);

my %chars;

while (<>) {
    chomp;
    my @chars = /(\p{Han})/g;
    @chars{@chars} = ();
}

$\ = "\n";

open my $out, ">:encoding(utf8)", "src/traditional_characters.txt";
print $out $_ for sort keys %chars;
close $out;
print "Produced src/traditional_characters.txt\n";
