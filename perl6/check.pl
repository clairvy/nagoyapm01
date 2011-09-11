#!/usr/bin/env perl

use strict;
use warnings;

sub parse_input {
    my ($fname) = @_;
    open my $fh, '<', $fname;
    chomp(my @lines = <$fh>);
    splice(@lines, 0, 2);
    close $fh;
    \@lines;
}

sub parse_output {
    my ($fname) = @_;
    open my $fh, '<', $fname;
    chomp(my @lines = <$fh>);
    close $fh;
    \@lines;
}

sub main {
    my $d_i = parse_input "input.txt";
    my $d_o = parse_output "output.txt";
    for my $i (0 .. @$d_i - 1) {
        my @buf = ($i + 1, $d_i->[$i]);
        if (length($d_o->[$i]) == 0) {
            push(@buf, 'skip');
        } else {
            push(@buf, $d_o->[$i]);
        }
        print join(' ', @buf), "\n";
    }
    return 0
}
exit main;
