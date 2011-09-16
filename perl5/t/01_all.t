use strict;
use Test::More;

BEGIN { use_ok 'Check' }

use Data::Dumper;
$Data::Dumper::Terse = 1;
use FindBin;

{
    my $fname = "$FindBin::RealBin/01in.txt";
    print $fname, "\n";
    my $expected = q#[
  [
    '5',
    '6',
    '12=E4D9HIF8=GN576LOABMTPKQSR0J'
  ],
  [
    '6',
    '5',
    '238=I67E9MBC1AF05HJKRLNGPDQSTO'
  ]
]
#;
    is(Data::Dumper->Dump([Check::parse_problem($fname)]), $expected);
}

done_testing;
