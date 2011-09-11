Perl6 = perl6
TIME = time

run:
	( cd perl6 && $(TIME) $(Perl6) check.p6 )
