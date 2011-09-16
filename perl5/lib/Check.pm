package Check;

use strict;
use warnings;

=head1 NAME

Check - check slide puzzle answer.

=head1 SYNOPSIS

  use Check;
  Check->run();

=head1 AUTHOR

NAGAYA Shinichiro<clairvy@gmail.com>

=head1 LICENSE

Copyright (c) NAGAYA Shinichiro

This module may be used, modified, and distributed under the same terms as Perl itself. Please see the license that came with your Perl distribution for details.

=cut

use 5.005;
no warnings "recursion";

our $VERSION = '1.0';

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
    my $next_board = nextAll($w, $h, $init, $hand);
    unless ($next_board) {
        return 'not ok';
    } else {
#            print print_board($w, $h, $next_board), "\n";
        return move($w, $h, $next_board, $last);
    }
}

sub found_zero {
    my ($board) = @_;
    index($board, '0');
}

sub swap {
    my ($init, $pos, $new_pos) = @_;
    my $new_board = $init;
    my $new_value = substr($init, $new_pos, 1);
    if ($new_value eq '=') {
        return;
    }
    substr($new_board, $new_pos, 1, substr($init, $pos, 1));
    substr($new_board, $pos, 1, $new_value);
    $new_board;
}

sub _next {
    my ($init, $step, $valid) = @_;
    my $pos = found_zero($init);
    my $new_pos = $pos + $step;
    unless ($valid->($new_pos)) {
         print("invalid new_pos: " . $new_pos, "\n");
        return;
    }
    swap($init, $pos, $new_pos);
}

sub nextAll {
    my ($w, $h, $init, $hand) = @_;
    if ('U' eq $hand) {
        my $step = -$w;
        my $valid = sub {!($_[0] < 0)};
        _next($init, $step, $valid);
    } elsif ('D' eq $hand) {
        my $step = +$w;
        my $valid = sub {$_[0] < length($init)};
        _next($init, $step, $valid);
    } elsif ('R' eq $hand) {
        my $step = +1;
        my $valid = sub {!($_[0] % $w == 0)};
        _next($init, $step, $valid);
    } elsif ('L' eq $hand) {
        my $step = -1;
        my $valid = sub {!(($_[0] % $w) == ($w - 1))};
        _next($init, $step, $valid);
    } else {
        print('unknown hand: ' . $hand);
        return;
    }
}

sub check {
    my ($problem, $answer) = @_;
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
}

sub main {
    my $problem = parse_problem "input.txt";
    my $answer = parse_answer "output.txt";
    check($problem, $answer);
    return 0
}

1;
