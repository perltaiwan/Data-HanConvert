#!/usr/bin/env perl

=head1 unihan2txt.pl

This program converts and extracts the tradition/simplified mapping from
Unihan_Variants.txt to the text mapping files named "characters_invariant.txt",
"characters_multivariant.txt", and "characters_singlevariant.txt".  The format
is described in README.md.

Unihan_Variants.txt can be found from the Unihan.zip distribution at
L<http://www.unicode.org/Public/UNIDATA/Unihan.zip>

=cut

use v5.14;
use strict;
use warnings;
use utf8;
use FindBin;
use IO::All;
use Cwd qw(realpath);
use JSON qw(encode_json);
use YAML;
use Unicode::UCD 'charscript';

sub u { chr(hex(substr($_[0],2))) }

my $uv_path = shift @ARGV or die "Usage: $FindBin::Script /path/of/Unihan_Variants.txt\n";
my $uv_io = io($uv_path)->utf8->chomp;

my %variants;
while(defined(my $line = $uv_io->getline)) {
    next if $line =~ /^#/;
    next if $line =~ /^\s*$/;
    my ($char, $type, @variants) = split /\s+/o, $line;
    next unless $type =~ /^(kSimplifiedVariant|kTraditionalVariant)$/o;

    ($char, @variants) = map { u($_) } ($char, @variants);

    for (@variants) {
        $variants{$type}{$char}{$_}++;
    }
}

# Cases in http://www.unicode.org/reports/tr38/#SCTC
# Taken from: https://en.wikipedia.org/wiki/Han_unification#Unicode_ranges
my $cjk_ideograph_ranges = [
    [0x4E00,  0x9FFF],
    [0x3400,  0x4DBF],
    [0x20000, 0x2A6DF],
    [0x2A700, 0x2B73F],
    [0x2B740, 0x2B81F],
];

my $dist_root = realpath( io->catdir($FindBin::Bin, "..") );
my $char_invariant_io = io->catfile($dist_root, "src", "characters_invariant.txt")->utf8->assert;
my $char_multivariant_io = io->catfile($dist_root, "src", "characters_multivariant.txt")->utf8->assert;
my $char_singlevariant_io = io->catfile($dist_root, "src", "characters_singlevariant.txt")->utf8->assert;

my %mappings_singlevariant;
my %mappings_multivariant;

for my $range (@$cjk_ideograph_ranges) {
    for (my $charcode = $range->[0]; $charcode <= $range->[1]; $charcode++) {
        my $c = chr($charcode);
        if ( !(exists $variants{kSimplifiedVariant}{$c}) && !(exists $variants{kTraditionalVariant}{$c}) ) {
            $char_invariant_io->println($c);
        } elsif ((exists $variants{kSimplifiedVariant}{$c}) && !(exists $variants{kTraditionalVariant}{$c})) {
            my @d = keys %{$variants{kSimplifiedVariant}{$c}};
            if (@d == 1) {
                $mappings_singlevariant{"$c $d[0]"}++;
            } else {
                my $d = join "," => @d;
                $mappings_multivariant{"$c $d"}++;
            }
        } elsif (!(exists $variants{kSimplifiedVariant}{$c}) && (exists $variants{kTraditionalVariant}{$c})) {
            my @d = keys %{$variants{kTraditionalVariant}{$c}};
            if (@d == 1) {
                $mappings_singlevariant{"$d[0] $c"}++;
            } else {
                my $d = join "," => @d;
                $mappings_multivariant{"$d $c"}++;
            }
        } elsif ((exists $variants{kSimplifiedVariant}{$c}) && (exists $variants{kTraditionalVariant}{$c})) {
            if (exists $variants{kSimplifiedVariant}{$c}{$c}) {
            } else {
            }
        }
    }
}

for (keys %mappings_singlevariant) {
    $char_singlevariant_io->println($_);
}
for (keys %mappings_multivariant) {
    $char_multivariant_io->println($_);
}
