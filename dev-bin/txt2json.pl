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
use JSON ();

my $json = JSON->new->utf8->pretty;
sub encode_json { $json->encode(@_) }

my $dist_root = realpath( io->catdir($FindBin::Bin, "..") );

sub build_hash {
    my ($io) = @_;
    my $array = [];
    while (defined(my $line = $io->getline)) {
        next if $line =~ /^(#|\s*$)/;
        my ($tc, $sc) = split " ", $line;
        push @$array, [$tc, $sc];
    }
    my @t2s_multi;
    my @s2t_multi;
    my $t2s = {};
    my $s2t = {};
    for (@$array) {
        my ($t,$s) = @$_;
        if ($t2s->{$t}) {
            push @t2s_multi, $t;
        }
        if ($s2t->{$s}) {
            push @s2t_multi, $s;
        }
        $t2s->{$t} = $s;
        $s2t->{$s} = $t;
    }
    delete @{$t2s}{@t2s_multi};
    delete @{$s2t}{@s2t_multi};
    return ($t2s, $s2t);
}

my ($t2s, $s2t) = build_hash io->catfile($dist_root, "src", "hanconvert.txt")->utf8->chomp;
io->catfile($dist_root, "share", "hanconvert_tw2cn_hash.json")->print(encode_json($t2s));
io->catfile($dist_root, "share", "hanconvert_cn2tw_hash.json")->print(encode_json($s2t));

($t2s, $s2t) = build_hash io->catfile($dist_root, "src", "characters_singlevariant.txt")->utf8->chomp;
io->catfile($dist_root, "share", "characters_tw2cn_hash.json")->print(encode_json($t2s));
io->catfile($dist_root, "share", "characters_cn2tw_hash.json")->print(encode_json($s2t));
