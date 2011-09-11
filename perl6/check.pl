#!/usr/bin/env perl

use strict;
use warnings;

sub parse_problem {
    my ($fname) = @_;
    open my $fh, '<', $fname;
    chomp(my @lines = <$fh>);
    close $fh;
    splice(@lines, 0, 2);
    @lines = map {[split /,/]} @lines;
    \@lines;
}

sub parse_answer {
    my ($fname) = @_;
    open my $fh, '<', $fname;
    chomp(my @lines = <$fh>);
    close $fh;
    \@lines;
}

sub main {
    my $problem = parse_problem "input.txt";
    my $answer = parse_answer "output.txt";
    for my $i (0 .. @$problem - 1) {
        my @buf = ($i + 1, join(',', @{$problem->[$i]}));
        if (length($answer->[$i]) == 0) {
            push(@buf, 'skip');
        } else {
            push(@buf, $answer->[$i]);
        }
        print join(' ', @buf), "\n";
    }
    return 0
}
exit main;
