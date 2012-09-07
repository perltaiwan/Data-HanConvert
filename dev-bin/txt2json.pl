#!/usr/bin/env perl

=name txt2json

This program converts src/hanconvert.txt to share/*.json JSON files are
overwritten after the program is done.

=cut

use strict;
use warnings;

use FindBin;
use IO::All;
use Cwd qw(realpath);
use JSON qw(encode_json);

my $dist_root = realpath( io->catdir($FindBin::Bin, "..") );

my $txt_io = io->catfile($dist_root, "src", "hanconvert.txt")->utf8->chomp;

my $hanconvert_array = [];
while(defined(my $line = $txt_io->getline)) {
    next if $line =~ /^(#|\s*$)/;
    my ($tc, $sc) = split " ", $line;
    push @$hanconvert_array, [$tc, $sc];
}

io->catfile($dist_root, "share", "hanconvert_array.json")->print(encode_json($hanconvert_array));

my $t2s = {};
my $s2t = {};
for(@$hanconvert_array) {
    $t2s->{$_->[0]} = $_->[1];
    $s2t->{$_->[1]} = $_->[0];
}

io->catfile($dist_root, "share", "hanconvert_tw2cn_hash.json")->print(encode_json($t2s));
io->catfile($dist_root, "share", "hanconvert_cn2tw_hash.json")->print(encode_json($s2t));
