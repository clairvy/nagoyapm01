#!/usr/bin/env perl

use strict;
use warnings;
no warnings "recursion";

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

sub print_board {
    my ($w, $h, $board) = @_;
    while (length($board) > 0) {
        print substr($board, 0, $w, ''), "\n";
    }
}

sub move {
    my ($w, $h, $init, $hands) = @_;
#    use Data::Dumper;
#    print Data::Dumper->Dump([$w, $h, $init, $hands]);
    if (0 == length($hands)) {
#        print("ok\n");
        return 'ok';
    }
    my $hand = substr($hands, 0, 1);
    my $last = substr($hands, 1);
    my $found_zero = sub {
        my ($board) = @_;
        index($board, '0');
    };
    my $swap = sub {
        my ($init, $pos, $new_pos) = @_;
        my $new_board = $init;
        my $new_value = substr($init, $new_pos, 1);
        if ($new_value eq '=') {
            return;
        }
        substr($new_board, $new_pos, 1, substr($init, $pos, 1));
        substr($new_board, $pos, 1, $new_value);
        $new_board;
    };
    my $next = sub {
        my ($init, $step, $valid) = @_;
        my $pos = $found_zero->($init);
        my $new_pos = $pos + $step;
        unless ($valid->($new_pos)) {
#            print("invalid new_pos: " . $new_pos, "\n");
            return 'not ok';
        }
        $swap->($init, $pos, $new_pos);
    };
    my $nextAll = {
                 U => sub {
                     my ($init) = @_;
                     my $step = -$w;
                     my $valid = sub {!($_[0] < 0)};
                     $next->($init, $step, $valid);
                 },
                 D => sub {
                     my ($init) = @_;
                     my $step = +$w;
                     my $valid = sub {$_[0] < length($init)};
                     $next->($init, $step, $valid);
                 },
                 R => sub {
                     my ($init) = @_;
                     my $step = +1;
                     my $valid = sub {!($_[0] % $w == 0)};
                     $next->($init, $step, $valid);
                 },
                 L => sub {
                     my ($init) = @_;
                     my $step = -1;
                     my $valid = sub {!(($_[0] % $w) == ($w - 1))};
                     $next->($init, $step, $valid);
                 },
                };
    if (exists($nextAll->{$hand})) {
        my $next_board = $nextAll->{$hand}->($init);
        if ($next_board) {
#            print print_board($w, $h, $next_board), "\n";
            move($w, $h, $next_board, $last);
        }
    } else {
        die 'unknow hand : ' . $hand;
    }
}

sub main {
    my $problem = parse_problem "input.txt";
    my $answer = parse_answer "output.txt";
    print('1..', scalar(@$problem), "\n");
    for my $i (0 .. @$problem - 1) {
        my @buf = ($i + 1, join(',', @{$problem->[$i]}));
        if (length($answer->[$i]) == 0) {
            push(@buf, '# TODO');
            unshift(@buf, 'not ok');
        } else {
            push(@buf, $answer->[$i]);
            unshift(@buf, move(@{$problem->[$i]}, $answer->[$i]));
        }
        print join(' ', @buf), "\n";
    }
    return 0
}
exit main;
