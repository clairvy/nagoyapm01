PERL5 = perl
PERL6 = perl6
TIME = time
DIFF = diff
OBJECTS = perl6/out5 perl6/out6

all: run6 run5

diff: $(OBJECTS)
	$(DIFF) $(OBJECTS)

run: run6
run6: perl6/out6
perl6/out6: perl6/check.p6
	( cd perl6 && $(TIME) $(PERL6) check.p6 > out6 )

run5: perl6/out5
perl6/out5: perl6/check.pl
	( cd perl6 && $(TIME) $(PERL5) check.pl > out5 )

clean:
	$(RM) $(RMF) $(OBJECTS)

hello:
	$(TIME) $(PERL6) -e 'say "Hello"'
	$(TIME) $(PERL5) -le 'print "Hello"'
