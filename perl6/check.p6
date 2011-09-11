#!/usr/bin/env perl6

use v6;

sub parse_problem($fname) {
    my $fh = open $fname;
    my @lines = $fh.lines;
    $fh.close;
    @lines.splice(0, 2);
    @lines;
}

sub parse_result($fname) {
    my $fh = open $fname;
    my @lines = $fh.lines;
    $fh.close;
    @lines;
}

# main 関数
sub MAIN (Str :$problem = "input.txt", Str :$result = "output.txt") {
    my @d_p = parse_problem $problem;
    my @d_r = parse_result $result;
    for 0 .. @d_p - 1 -> $i {
        my @buf = $i + 1, @d_p[$i];
        if 0 == @d_r[$i].chars {
            @buf.push("skip");
        } else {
            @buf.push(@d_r[$i]);
        }
        say "@buf[]";
    }
    return 0
}
