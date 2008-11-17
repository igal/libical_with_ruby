require 'mkmf'
dir_config('LibicalWrap')
# FIXME What's the right way to pass INCFLAGS?
$INCFLAGS << ' -I.. -I../libical -I../libicalss'
# FIXME What's the right way to tell it to include extra .o files?
CONFIG['LDSHARED'] << ' ' << Dir['../libical/*.o', '../libicalss/*.o', 'LibicalWrap.o'].join(' ')
create_makefile('LibicalWrap')
