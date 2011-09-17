use v6;
use Test;

use Check;

my $pwd = %*ENV<PWD>;
sub pwd {
    return "$pwd/t";
}

{
    my $expected = [$("5", "6", "12=E4D9HIF8=GN576LOABMTPKQSR0J"), $("6", "5", "238=I67E9MBC1AF05HJKRLNGPDQSTO")];
    my $fname = "{pwd}/01in.txt";
    is(Check.parse_problem($fname), $expected, 'parse_problem');
}

{
    my $expected = ["UUUURDDDLLUUULLDDRRRUUURDDLULLLDDDRRUUULLDDRRRRDDLURULDLLDRULLDRRULDLURRRRD", "LLURDRURURDLDRUULDLLLLDDRDRUUUULLDRRDLDLURRDRRRULDLURRDD"];
    my $fname = "{pwd}/01out.txt";
    is(Check.parse_answer($fname), $expected, 'parse_answer');
}

{
    is(Check.found_zero('0'), 0, 'found 0');
    is(Check.found_zero('a0'), 1, 'found 1');
}

{
    is(Check.swap('abcd', 0, 3), 'dbca', 'normal swap');
    is(Check.swap('abc=', 0, 3), '', 'fail to wall');
}

{
    is(Check.next('012345678',  1, -> $_ {1}), '102345678', 'move 1');
    is(Check.next('123405678',  3, -> $_ {1}), '123475608', 'move 2');
    is(Check.next('123405678', -3, -> $_ {1}), '103425678', 'move 3');
    is(Check.next('123405678', -3, -> $_ {0}), '', 'next fail');
}

{
    is(Check.nextAll(3, 3, '123405678', 'U'), '103425678', 'move U');
    is(Check.nextAll(3, 3, '123405678', 'D'), '123475608', 'move D');
    is(Check.nextAll(3, 3, '123405678', 'R'), '123450678', 'move R');
    is(Check.nextAll(3, 3, '123405678', 'L'), '123045678', 'move L');
    is(Check.nextAll(3, 3, '103425678', 'U'), '', 'move U fail');
    is(Check.nextAll(3, 3, '123456708', 'D'), '', 'move D fail');
    is(Check.nextAll(3, 3, '123450678', 'R'), '', 'move R fail');
    is(Check.nextAll(3, 3, '123045678', 'L'), '', 'move L fail');
}

{
    is(Check.move(5, 6, "12=E4D9HIF8=GN576LOABMTPKQSR0J", "UUUURDDDLLUUULLDDRRRUUURDDLULLLDDDRRUUULLDDRRRRDDLURULDLLDRULLDRRULDLURRRRD"), 'ok', 'ok');
    is(Check.move(5, 6, "12=E4D9HIF8=GN576LOABMTPKQSR0J", "DUUUURDDDLLUUULLDDRRRUUURDDLULLLDDDRRUUULLDDRRRRDDLURULDLLDRULLDRRULDLURRRRD"), 'not ok', 'not ok');
}

done;
