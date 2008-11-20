NOTES ON RUBY BINDINGS
======================

Igal Koshevoy / Calagator.org / 2008-11-19

RATIONALE FOR CONSIDERING LIBICAL

The libical is a popular iCalendar library used by Mozilla, Gnome, KDE and
other products. It could provide us with recurring events, more power, greater
stability and better long-term investment than the VPIM parser.

If libical can be improved, it'll help many others using it. This code could
also provide the basis for Python, PHP and Java libraries too.

ISSUES WITH LIBICAL

libical has much baggage. It's a big, confusing C code base. It has very little
documentation and provides no working examples. The Python and Perl bindings
that libical ships with either never worked or have been broken for years.
People tried creating Ruby bindings years ago, but failed. Building binary Ruby
bindings for Windows will be a phenomenal pain.

PROGRESS WITH RUBY BINDINGS FOR LIBICAL

I wrote Ruby bindings for this by reworking the broken Python bindings and
adding lots of elbow grease in the form of build scripts. I can use trivial
functions within it just fine from Ruby, but am baffled by the libical API.
Unless I can do trivial operations like getting events from a data stream,
there's not much sense in working further on th Ruby bindings. There's a couple
extra .rb files in "src/ruby" that came from the last abandoned Ruby bindings
for libical project, which don't work but may prove useful as guidance.

GETTING STARTED WITH LIBICAL FOR C AND RUBY DEVELOPERS

- Download code from: http://github.com/igal/libical_with_ruby/tree/master

- Or clone code from: git@github.com:igal/libical_with_ruby.git

- Read "doc/UsingLibical.txt", although it's either wrong, obsolete or too
  confusing to explain how to perform the most trivial operations

- Perform high-level compile of libical's C code:
    ./configure && make

- Review "examples/parse_string_main.c", my trivial example that reads a file
  into a large string, parses it, and then extracts events and properties
  (e.g., summary of the event). To compile and run the C example:

    make && (cd examples && rake -v parse_string_main)

- To compile the Ruby bindings, which demonstrate how to run a trivial libical
  function, review "src/ruby/Rakefile" and run:

    make && (cd src/ruby && rake -v run)
