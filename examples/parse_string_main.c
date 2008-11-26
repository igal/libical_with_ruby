/* parse_string_main.c -- Demonstrates parsing of an iCalendar string and analysis */
#include <stdio.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <libical/ical.h>

#include <stdlib.h>

// Return contents of +filename+.
char* file_read(char* filename)
{
	FILE* handle;
	int file_length;
	char* data;

	handle = fopen(filename, "r");
	if (handle) {
		fseek(handle, 0, SEEK_END);
		file_length = ftell(handle);
		fseek(handle, 0, SEEK_SET);
		data = (char*) malloc(file_length+1);
		fread(data, file_length, 1, handle);
		fclose(handle);
	} else {
		data = "";
		printf("ERROR - Couldn't open file: %s\n", filename);
	}

	return data;
}

int main(int argc, char* argv[])
{
    // parse_text(argc, argv);

	char* data;

//	data = file_read("../test-data/2445.ics");
	data = file_read(argv[1]);
	icalcomponent* calendar = icalcomponent_new_from_string(data);

	// TODO Figure out how to match VVENUE items to VEVENTs.
	icalcompiter component_iter;
	for(
	   component_iter = icalcomponent_begin_component(calendar, ICAL_VEVENT_COMPONENT);
	   icalcompiter_deref(&component_iter)!= 0;
	   icalcompiter_next(&component_iter)
	) {
		const icalcomponent* component = icalcompiter_deref(&component_iter);

		icalproperty* uid_property = icalcomponent_get_first_property(component, ICAL_UID_PROPERTY);
		const char* uid = icalproperty_get_uid(uid_property);
		printf("* uid: %s\n", uid);

		icalproperty* summary_property = icalcomponent_get_first_property(component, ICAL_SUMMARY_PROPERTY);
		const char* summary = icalproperty_get_summary(summary_property);
		printf("- summary: %s\n", summary);

		icalproperty* dtstart_property = icalcomponent_get_first_property(component, ICAL_DTSTART_PROPERTY);
		const icaltimetype dtstart = icalproperty_get_dtstart(dtstart_property);
		printf("- dtstart: %0.4d-%0.2d-%0.2d %0.2d:%0.2d:%0.2d\n", dtstart.year, dtstart.month, dtstart.day, dtstart.hour, dtstart.minute, dtstart.second);
        printf("\n");

		free(uid);
		icalproperty_free(uid_property);
		free(summary);
		icalproperty_free(summary_property);
		// TODO Free dtstart. It doesn't support `free` and there's no `icaltimetype_free`.
		icalproperty_free(dtstart_property);
		icalcomponent_free(component);
	}

	icalcomponent_free(calendar);
	free(data);

	printf("DONE!\n");
    return 0;
}
