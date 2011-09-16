#!/usr/bin/env perl6

use v6;
use Check;

# main 関数
sub MAIN (Str :$problem = "input.txt", Str :$answer = "output.txt") {
    Check.run($problem, $answer);
    return 0
}
