use v6;
use Test;

use Check;

{
    my $pwd = %*ENV<PWD>;
    my $expected = '[("5", "6", "12=E4D9HIF8=GN576LOABMTPKQSR0J"), ("6", "5", "238=I67E9MBC1AF05HJKRLNGPDQSTO")]';
    my $fname = "$pwd/t/01in.txt";
    is(Check.parse_problem($fname).perl, $expected);
}

done;
