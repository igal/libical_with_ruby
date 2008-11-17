NOTES ON RUBY BINDINGS
======================

Igal Koshevoy / Calagator.org / 2008-11-17

HELP NEEDED WITH TRIVIAL C IMPLEMENTATION OF LIBICAL CALL

I'd be grateful if someone could provide me with a trivial C program that uses libical to read a string of iCalendar data, returns an array of events, and then iterates over these to print the contents of these data structures.

Either the C code is buggy or too confusing, but I can't figure out how to do the above task. I've tried three different ways, but they all return nulls instead of the promised data structures.

RATIONALE FOR CONSIDERING LIBICAL

The libical is a popular iCalendar library used by Mozilla, Gnome, KDE and other products. It could provide us with recurring events, more power, greater stability and better long-term investment than the VPIM parser.

If libical can be improved, it'll help many others using it. This code could also provide the basis for Python, PHP and Java libraries too.

ISSUES WITH LIBICAL

libical has much baggage. It's a big, confusing C code base. It has very little documentation and provides no working examples. The Python and Perl bindings that libical ships with either never worked or have been broken for years. People tried creating Ruby bindings years ago, but failed. Building binary Ruby bindings for Windows will be a phenomenal pain.

PROGRESS WITH RUBY BINDINGS FOR LIBICAL

I wrote Ruby bindings for this by reworking the broken Python bindings and adding lots of elbow grease in the form of build scripts. I can use trivial functions within it just fine from Ruby, but am baffled by the libical API. Unless I can do trivial operations like getting events from a data stream, there's not much sense in working further on th Ruby bindings. There's a couple extra .rb files in "src/ruby" that came from the last abandoned Ruby bindings for libical project, which don't work but may prove useful as guidance.

GETTING STARTED WITH LIBICAL FOR C AND RUBY DEVELOPERS

* Download code from: http://github.com/igal/libical_with_ruby/tree/master
* Or clone code from: git@github.com:igal/libical_with_ruby.git
* Read "doc/UsingLibical.txt", although it's either wrong, obsolete or too confusing to explain how to perform the most trivial operations
* Review "src/libical/icalparser.c", which does the parsing and its code is the only real documentation
* Review "examples/parse_text_main.c", my trivial example that parses a file and displays its contents. However, I cannot access the data structures. When writing your code, please review this file AND the "run" task in "examples/Rakefile", because you really don't want to waste time trying to setup the environment yourself because I already have. To compile and run the C example:
    ./configure && make && (cd examples && rake -v run)
* To compile the Ruby bindings, which demonstrate how to run a trivial libical function, review "src/ruby/Rakefile" and run:
    ./configure && make && (cd src/ruby && rake -v run)
* To rerun the examples after you've made a change to C code, you'll need to rerun one of the two commands above but should leave out the "./configure" step.
