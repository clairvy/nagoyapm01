PERL5 = perl
PERL6 = perl6
TIME = time
DIFF = diff
DIFF3 = diff3
OBJECTS = perl5/out perl6/out scala/outs
SBT = xsbt
CP = project/boot/scala-2.9.1/lib/jansi.jar:project/boot/scala-2.9.1/lib/jline.jar:project/boot/scala-2.9.1/lib/scala-compiler.jar:project/boot/scala-2.9.1/lib/scala-library.jar:target/scala-2.9.1.final/classes
JAVA = java
JAVA_OPTS =
MAIN = Main
ARGS =
PROVE = prove
PARROT = parrot

all: run6 run5 runs runp runpbc

diff: $(OBJECTS)
	$(DIFF3) $(OBJECTS)

testpbc: perl6/check.pbc
	( cd perl6 && $(PROVE) -e $(PARROT) check.pbc )
runpbc: perl6/outpbc
perl6/outpbc: perl6/check.pbc
	( cd perl6 && $(TIME) $(PARROT) check.pbc > outpbc )
perl6/check.pbc: perl6/check.pir
	( cd perl6 && $(TIME) $(PARROT) -o check.pbc check.pir )

test6:
	( cd perl6 && env PERL6LIB=lib $(PROVE) -e $(PERL6) bin/check.p6 )
run: run6
run6: perl6/out
perl6/out: perl6/bin/check.p6 perl6/lib/Check.pm6
	( cd perl6 && env PERL6LIB=lib $(TIME) $(PERL6) bin/check.p6 > out )

testpir:
	( cd perl6 && env PERL6LIB=blib/lib $(PROVE) -e $(PERL6) bin/check.p6 )
runp: perl6/outp
perl6/outp: perl6/blib/lib/Check.pir
	( cd perl6 && env PERL6LIB=blib/lib $(TIME) $(PERL6) bin/check.p6 > outp )
perl6/blib/lib/Check.pir: perl6/lib/Check.pm6
	( cd perl6 && ufo )
	( cd perl6 && make )
	( cd perl6 && make test )

test5:
	( cd perl5 && $(PROVE) blib/script/check.pl )
run5: perl5/out
perl5/out: perl5/blib/script/check.pl
	( cd perl5 && $(TIME) $(PERL5) blib/script/check.pl > out )
perl5/blib/script/check.pl: perl5/check.pl
	( cd perl5 && $(PERL5) Makefile.PL )
	( cd perl5 && $(MAKE) )

tests:
	( cd scala && $(PROVE) -e "$(JAVA) $(JAVA_OPTS) -cp $(CP)" $(MAIN) $(ARGS) )
runs: scala/outs
scala/outs: scala/target/scala-2.9.1.final/classes/Main.class
	( cd scala && $(TIME) $(JAVA) $(JAVA_OPTS) -cp $(CP) $(MAIN) $(ARGS) > outs )
compile: scala/target/scala-2.9.1.final/classes/Main.class
scala/target/scala-2.9.1.final/classes/Main.class: scala/check.scala
	( cd scala && $(TIME) $(SBT) compile )

clean:
	$(RM) $(RMF) $(OBJECTS)

hello:
	$(TIME) $(PERL6) -e 'say "Hello"'
	$(TIME) $(PERL5) -le 'print "Hello"'
