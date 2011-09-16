use v6;
use Test;

use Check;

my $pwd = %*ENV<PWD>;
sub pwd {
    return "$pwd/t";
}

{
    my $expected = [$("5", "6", "12=E4D9HIF8=GN576LOABMTPKQSR0J"), $("6", "5", "238=I67E9MBC1AF05HJKRLNGPDQSTO")].perl;
    my $fname = "{pwd}/01in.txt";
    is(Check.parse_problem($fname).perl, $expected);
}

{
    my $expected = ["UUUURDDDLLUUULLDDRRRUUURDDLULLLDDDRRUUULLDDRRRRDDLURULDLLDRULLDRRULDLURRRRD", "LLURDRURURDLDRUULDLLLLDDRDRUUUULLDRRDLDLURRDRRRULDLURRDD"].perl;
    my $fname = "{pwd}/01out.txt";
    is(Check.parse_answer($fname).perl, $expected);
}

done;
