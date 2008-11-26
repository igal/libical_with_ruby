NOTES ON RUBY BINDINGS
======================

Igal Koshevoy / Calagator.org / 2008-11-26


SECTIONS
- SUMMARY
- WHY LIBICAL
- ISSUES WITH LIBICAL
- FILES AND DIRECTORIES
- GETTING STARTED


SUMMARY

These notes describe initial work being done on providing Ruby bindings for
libical. Work on these can be found in the `src/ruby` directory. The
`icalagator.rb` file provides a high-level Ruby wrapper for libical. The
various `example_*.rb` files provide runnable example programs demonstrating
how to use the bindings and wrapper.


TASKS

- Write C example for extracting unknown properties. E.g., libical doesn't seem
  to be able to extract the POSTALCODE property from a VVENUE because it's not
  within the iCalendar specification. Resolving this may be tricky because
  according to `icalparser_add_line`, when an unknown property is found, its
  payload is discarded and an error property is added instead containing the
  string "Parse error in property name". A fix may require adding a field to
  `icalproperty` for storing the original payload and property name (e.g.,
  "POSTALCODE" and "97201"), and accessors to get these.
- Write Ruby wrapper for extracting unknown properties.

- Write C example for extracting recurring events.
- Write Ruby wrapper for extracting recurring events.

- Write C example for extracting times and converting them to UTC. The
  low-level routines provide a way to extract time and timezone, but it's
  unclear how to combine these.
- Write Ruby wrapper for hiding conversion of times to UTC.


WHY LIBICAL

libical is a iCalendar library used by Mozilla, KDE, Gnome and others. It
provides more features than any open source iCalendar library available and is
the most-widely used.

Writing Ruby bindings to libical, rather than improving upon native-Ruby
libraries like VPIM, may be a good way to gain access to many features and a
higher-quality code base, and provide a better long-term investment.

Much of this work will also be reusable, making it much easier to write
bindings and wrappers for languages like Python, PHP, Java and Perl.


ISSUES WITH LIBICAL

libical is a large, complex C library. Most of libical's complexity is the
direct result of the iCalendar specification being large and inconsistent.

Using the libical bindings directly from Ruby is painful because it requires a
thorough understanding of C, iCalendar, and libical implementation.

Writing an easy-to-use Ruby wrapper for libical is vital, but difficult because
of the impedance mismatch between C and Ruby. The libical C code is
self-contained, data-oriented, and strongly-typed. The Ruby wrapper needs to be
idiomatic, object-oriented, and duck-typed.

The libical source ships with for Python and Perl, but these either never
worked or have ceased working long ago.

Compiling the bindings for Microsoft Windows will be a phenomenal pain.


FILES AND DIRECTORIES

- doc/UsingLibical.txt : Provides limited documentation for C API.

- examples/parse_string_main.c : Provides runnable C example that parses a
  string and prints its contents. You can run it by executing:

    make && (cd examples && rake -v parse_string_main)

- examples/Rakefile : Provides wrapper for compiling and running C examples.

- src/ruby/LibicalWrap.i : Provides instructions for SWIG on how to expose C
  functions and structs to other languages.

- src/ruby/LibicalWrap.so : Provides low-level Ruby bindings. To
  use this, you just `require` the file from Ruby.

- src/ruby/icalagator.rb : Provides high-level Ruby wrapper that makes it
  easier to use libical.

- src/ruby/Rakefile : Provides wrapper for compiling bindings.


GETTING STARTED

- Download code from: http://github.com/igal/libical_with_ruby/tree/master

- Or clone code from: git@github.com:igal/libical_with_ruby.git

- Compile the C code:

    ./configure && make

- Run the "examples/parse_string_main.c", an example program that parses a
  string of iCalendar data and prints out the extracted fields:

    make && (cd examples && rake example)

- Run the "src/ruby/example_reader.rb", an example program that parses a string
  of iCalendar data and prints out the extracted fields:

    make && (cd src/ruby && rake example)
