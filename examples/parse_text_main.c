/* parse_text_main.c -- Demonstrates line-by-line parsing of a iCalendar document */
#include <stdio.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <libical/ical.h>

#include <stdlib.h>

/* The icalparser_get_line routine will create a single *content* line
out of one or more input lines. The content line is all of the
properties and values for a single property, and it can span several
input lines. So, icalparser_get_line will need to be able to get more
data on its own. Read_string is a routine that does this. You can
write your own version of read stream to get data from other types of
files, sockets, etc. */

char* read_stream(char *s, size_t size, void *d)
{
  char *c = fgets(s,size, (FILE*)d);

  return c;

}

void parse_text(int argc, char* argv[])
{

    char* line;
    FILE* stream;
    icalcomponent *c;

    /* Create a new parser object */
    icalparser *parser = icalparser_new();

    stream = fopen(argv[1],"r");

    assert(stream != 0);

    /* Tell the parser what input routie it should use. */
    icalparser_set_gen_data(parser,stream);

    do{

	/* Get a single content line by making one or more calls to
           read_stream()*/
	line = icalparser_get_line(parser,read_stream);
        printf("line: %s\n", line);

	/* Now, add that line into the parser object. If that line
           completes a component, c will be non-zero */
	c = icalparser_add_line(parser,line);


	if (c != 0){
	    char *temp = icalcomponent_as_ical_string_r(c);
	    printf("component: %s", temp);
	    free(temp);

	    printf("\n---------------\n");

	    icalcomponent_free(c);
	}

    } while ( line != 0);


    icalparser_free(parser);
}

int main(int argc, char* argv[])
{
    parse_text(argc, argv);
    return 0;
}
