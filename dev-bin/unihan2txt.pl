#!/usr/bin/env perl

=head1 unihan2txt.pl

This program converts and extracts the tradition/simplified mapping from
Unihan_Variants.txt to the text mapping file named "characters.txt" with format
described in README.md. The order in the file is sorted by the unicode codepoint
of the first column.

Unihan_Variants.txt can be found from the Unihan.zip distribution at
L<http://www.unicode.org/Public/UNIDATA/Unihan.zip>

=cut

use strict;
use warnings;
use utf8;
use FindBin;
use IO::All;
use Cwd qw(realpath);
use JSON qw(encode_json);

sub u { chr(hex(substr($_[0],2))) }

my $uv_path = shift @ARGV or die "Usage: $FindBin::Script /path/of/Unihan_Variants.txt\n";
my $uv_io = io($uv_path)->utf8->chomp;

my $dist_root = realpath( io->catdir($FindBin::Bin, "..") );
my $char_io = io->catfile($dist_root, "src", "characters.txt")->utf8->assert;

$char_io->unlink if $char_io->exists;
$char_io->println("# Generated with unihan2txt.pl");

my %mappings;
while(defined(my $line = $uv_io->getline)) {
    next if $line =~ /^#/;
    next if $line =~ /^\s*$/;
    my ($char, $type, @variants) = split /\s+/o, $line;
    next unless $type =~ /^(kSimplifiedVariant|kTraditionalVariant)$/o;

    if ($type eq "kSimplifiedVariant") {
        for (@variants) {
            $mappings{ u($char) . " " . u($_) } = 1;
        }
    }
    else {
        for (@variants) {
            $mappings{ u($_) . " " . u($char) } = 1;
        }
    }
}

# blacklist
delete @mappings{
    "闆 板",
    "穀 谷",
};

for (sort keys %mappings) {
    $char_io->println($_);
}
