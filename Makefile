PERL5 = perl
PERL6 = perl6
TIME = time
DIFF = diff
DIFF3 = diff3
OBJECTS = perl6/out5 perl6/out6 scala/outs
SBT = xsbt
CP = project/boot/scala-2.9.1/lib/jansi.jar:project/boot/scala-2.9.1/lib/jline.jar:project/boot/scala-2.9.1/lib/scala-compiler.jar:project/boot/scala-2.9.1/lib/scala-library.jar:target/scala-2.9.1.final/classes
JAVA = java
JAVA_OPTS =
MAIN = Main
ARGS =
PROVE = prove

all: run6 run5 runs

diff: $(OBJECTS)
	$(DIFF3) $(OBJECTS)

test6:
	( cd perl6 && $(PROVE) -e $(PERL6) check.p6 )
run: run6
run6: perl6/out6
perl6/out6: perl6/check.p6
	( cd perl6 && $(TIME) $(PERL6) check.p6 > out6 )

test5:
	( cd perl6 && $(PROVE) check.pl )
run5: perl6/out5
perl6/out5: perl6/check.pl
	( cd perl6 && $(TIME) $(PERL5) check.pl > out5 )

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
