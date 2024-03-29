class Check {
    method parse_problem($fname) {
        my $fh = open $fname;
        my @lines = $fh.lines;
        $fh.close;
        @lines.splice(0, 2);
        @lines = @lines.map: {$(.split(/\,/))};
        @lines;
    }

    method parse_answer($fname) {
        my $fh = open $fname;
        my @lines = $fh.lines;
        $fh.close;
        @lines;
    }

    method found_zero($board) {
        index($board, '0');
    }

    method swap($init, $pos, $new_pos) {
        my $new_board is rw = $init;
        my $new_value = $init.substr($new_pos, 1);
        if ($new_value eq '=') {
            '' # false
        } else {
            my @pair;
            if ($pos < $new_pos) {
                @pair = $pos, $new_pos;
            } else {
                @pair = $new_pos, $pos;
            }
            $init.substr(0, @pair[0])
          ~ $init.substr(@pair[1], 1)
          ~ $init.substr(@pair[0] + 1, @pair[1] - (@pair[0] + 1))
          ~ $init.substr(@pair[0], 1)
          ~ $init.substr(@pair[1] + 1);
        }
    }

    method next($init, $step, $valid) {
        my $pos = self.found_zero($init);
        my $new_pos = $pos + $step;
        if (!$valid($new_pos)) {
            '' # false
        } else {
            self.swap($init, $pos, $new_pos);
        }
    }

    method nextAll($w, $h, $init, $hand) {
        if ('U' eq $hand) {
            my $step = -$w;
            my $valid = -> $pos {!($pos < 0)};
            self.next($init, $step, $valid);
        } elsif ('D' eq $hand) {
            my $step = +$w;
            my $valid = -> $pos {$pos < $init.chars};
            self.next($init, $step, $valid);
        } elsif ('R' eq $hand) {
            my $step = +1;
            my $valid = -> $pos {!(($pos % $w) == 0)};
            self.next($init, $step, $valid);
        } elsif ('L' eq $hand) {
            my $step = -1;
            my $valid = -> $pos {!(($pos % $w) == ($w - 1))};
            self.next($init, $step, $valid);
        } else {
            say('unknown hand: ' ~ $hand);
            '' # false
        }
    }

    method move(Int $w, Int $h, Str $init, Str $hands) {
        unless ($hands.chars > 0) {
            return 'ok';
        }
        my $hand = $hands.substr(0, 1);
        my $last = $hands.substr(1);
        my $next_board = self.nextAll($w, $h, $init, $hand);
        if ($next_board.chars == 0) {
            return 'not ok';
        } else {
            return self.move($w, $h, $next_board, $last);
        }
    }

    method check(@problem, @answer) {
        say('1..', @problem.elems);
        for 0 .. @problem - 1 -> $i {
            my @buf = $i + 1, @problem[$i].join(',');
            if 0 == @answer[$i].chars {
                @buf.push("# TODO");
                @buf.unshift("not ok");
            } else {
                @buf.push(@answer[$i]);
                @buf.unshift(self.move(@problem[$i][0].Int, @problem[$i][1].Int, @problem[$i][2], @answer[$i]));
            }
            say "@buf[]";
        }
    }

    method run($problem, $answer) {
        my @problem = self.parse_problem($problem);
        my @answer = self.parse_answer($answer);
        self.check(@problem, @answer);
    }
}
