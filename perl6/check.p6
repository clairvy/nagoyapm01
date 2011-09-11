#!/usr/bin/env perl6

use v6;

sub parse_problem($fname) {
    my $fh = open $fname;
    my @lines = $fh.lines;
    $fh.close;
    @lines.splice(0, 2);
    @lines = @lines.map: {$(.split(/\,/))};
    @lines;
}

sub parse_answer($fname) {
    my $fh = open $fname;
    my @lines = $fh.lines;
    $fh.close;
    @lines;
}

# main 関数
sub MAIN (Str :$problem = "input.txt", Str :$answer = "output.txt") {
    my @problem = parse_problem $problem;
    my @answer = parse_answer $answer;
    for 0 .. @problem - 1 -> $i {
        my @buf = $i + 1, @problem[$i].join(',');
        if 0 == @answer[$i].chars {
            @buf.push("skip");
        } else {
            @buf.push(@answer[$i]);
        }
        say "@buf[]";
    }
    return 0
}
