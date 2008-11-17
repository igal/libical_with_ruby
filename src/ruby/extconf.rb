require 'mkmf'
dir_config('LibicalWrap')
$INCFLAGS << ' -I.. -I../libical -I../libicalss'
create_makefile('LibicalWrap')
