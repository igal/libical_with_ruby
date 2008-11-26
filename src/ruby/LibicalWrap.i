/* -*- Mode: C -*-*/
/*======================================================================
  FILE: ical.i

  (C) COPYRIGHT 1999 Eric Busboom
  http://www.softwarestudio.org

  The contents of this file are subject to the Mozilla Public License
  Version 1.0 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
  the License for the specific language governing rights and
  limitations under the License.

  The original author is Eric Busboom

  Contributions from:
  Graham Davison (g.m.davison@computer.org)

  ======================================================================*/  

%module LibicalWrap


%{
#include "ical.h"
#include "icalss.h"

#include <sys/types.h> /* for size_t */
#include <time.h>

%}


#include "fcntl.h" /* For Open flags */

typedef void icalcomponent;
typedef void icalproperty;

icalcomponent* icalparser_parse_string(char* str);


/* actually takes icalcomponent_kind */
icalcomponent* icalcomponent_new(int kind);
icalcomponent* icalcomponent_new_clone(icalcomponent* component);
icalcomponent* icalcomponent_new_from_string(char* str);

const char* icalcomponent_kind_to_string(int kind);
int icalcomponent_string_to_kind(const char* string);


char* icalcomponent_as_ical_string(icalcomponent* component);

void icalcomponent_free(icalcomponent* component);
int icalcomponent_count_errors(icalcomponent* component);
void icalcomponent_strip_errors(icalcomponent* component);
void icalcomponent_convert_errors(icalcomponent* component);

icalproperty* icalcomponent_get_current_property(icalcomponent* component);

icalproperty* icalcomponent_get_first_property(icalcomponent* component,
					      int kind);
icalproperty* icalcomponent_get_next_property(icalcomponent* component,
					      int kind);

icalcomponent* icalcomponent_get_current_component (icalcomponent* component);

icalcomponent* icalcomponent_get_first_component(icalcomponent* component,
					      int kind);
icalcomponent* icalcomponent_get_next_component(icalcomponent* component,
					      int kind);

void icalcomponent_add_property(icalcomponent* component,
				icalproperty* property);

void icalcomponent_remove_property(icalcomponent* component,
				   icalproperty* property);


void icalcomponent_add_component(icalcomponent* parent,
				icalcomponent* child);

void icalcomponent_remove_component(icalcomponent* parent,
				icalcomponent* child);

int icalcomponent_count_components(icalcomponent* component,
				   icalcomponent_kind kind);

icalcomponent* icalcomponent_get_inner(icalcomponent* comp);

icalcomponent* icalcomponent_get_parent(icalcomponent* component);
int icalcomponent_isa(icalcomponent* component);

int icalrestriction_check(icalcomponent* comp);

/* actually takes icalproperty_kind */
icalproperty* icalproperty_new(int kind);

icalproperty* icalproperty_new_from_string(char* str);

char* icalproperty_as_ical_string(icalproperty *prop);

void icalproperty_set_parameter_from_string(icalproperty* prop,
                                          const char* name, const char* value);
const char* icalproperty_get_parameter_as_string(icalproperty* prop,
                                                 const char* name);
void icalproperty_remove_parameter_by_name(icalproperty* prop,
                                           const char *name);

void icalproperty_set_value_from_string(icalproperty* prop,const char* value, const char * kind);

icalvalue* icalproperty_get_value(const icalproperty* prop);
const char* icalproperty_get_value_as_string(icalproperty* prop);
char* icalproperty_get_value_as_string_r(const icalproperty* prop);
icalcomponent* icalproperty_get_parent(icalproperty* property);

const char* icalproperty_kind_to_string(int kind);
int icalproperty_string_to_kind(const char* string);
int icalproperty_string_to_enum(const char* str);
int icalproperty_enum_belongs_to_property(int kind, int e);
int icalproperty_kind_to_value_kind(int kind);

/* Iterate through the parameters */
icalparameter* icalproperty_get_first_parameter(icalproperty* prop, icalparameter_kind kind);
icalparameter* icalproperty_get_next_parameter(icalproperty* prop, icalparameter_kind kind);

/* Deal with X properties */

void icalproperty_set_x_name(icalproperty* prop, const char* name);
const char* icalproperty_get_x_name(icalproperty* prop);

/* Return the name of the property -- the type name converted to a
   string, or the value of _get_x_name if the type is and X property */
const char* icalproperty_get_name (const icalproperty* prop);


int icalerror_supress(const char* error);
void icalerror_restore(const char* error, int es);
char* icalerror_perror();
void icalerror_clear_errno(void);

icalvalue_kind icalvalue_isa(const icalvalue* value);
icalvalue_kind icalparameter_value_to_value_kind(icalparameter_value value);
const char* icalvalue_kind_to_string(int kind);
int icalvalue_string_to_kind(const char* str);
struct icaltimetype icalvalue_get_datetime (const icalvalue* value);

char* icalparameter_as_ical_string(icalparameter* parameter);

const char* icalparameter_kind_to_string(int kind);
int icalparameter_string_to_kind(const char* string);

icalparameter_kind icalparameter_isa(icalparameter* parameter);
int icalparameter_isa_parameter(void* param);

int* icallangbind_new_array(int size);
void icallangbind_free_array(int* array);
int icallangbind_access_array(int* array, int index);



/* int icalrecur_expand_recurrence(char* rule, int start, 
				int count, int* array);*/
int icalrecur_expand_recurrence(char* rule, int start, 
				int count, time_t* array);


/* Iterate through properties, components and parameters using strings for the kind */
icalproperty* icallangbind_get_first_property(icalcomponent *c,
                                              const char* prop);

icalproperty* icallangbind_get_next_property(icalcomponent *c,
                                              const char* prop);

icalcomponent* icallangbind_get_first_component(icalcomponent *c,
                                              const char* comp);

icalcomponent* icallangbind_get_next_component(icalcomponent *c,
                                              const char* comp);

icalparameter* icallangbind_get_first_parameter(icalproperty *prop);

icalparameter* icallangbind_get_next_parameter(icalproperty *prop);


/* Return a string that can be evaluated in perl or python to
   generated a hash that holds the property's name, value and
   parameters. Sep is the hash seperation string, "=>" for perl and
   ":" for python */
const char* icallangbind_property_eval_string(icalproperty* prop, char* sep);

int icallangbind_string_to_open_flag(const char* str);

const char* icallangbind_quote_as_ical(const char* str);

/***********************************************************************
 Time routines 
***********************************************************************/


struct icaltimetype
{
	int year;
	int month;
	int day;
	int hour;
	int minute;
	int second;
};	


/* Convert seconds past UNIX epoch to a timetype*/
struct icaltimetype icaltime_from_timet(int v, int is_date);

/** Convert seconds past UNIX epoch to a timetype, using timezones. */
struct icaltimetype icaltime_from_timet_with_zone(int tm,
        int is_date, icaltimezone *zone);

/* Return the time as seconds past the UNIX epoch */
/* Normally, this returns a time_t, but SWIG tries to turn that type
   into a pointer */
int icaltime_as_timet(struct icaltimetype tt);

/* Return a string represention of the time, in RFC2445 format. The
   string is owned by libical */
char* icaltime_as_ical_string(struct icaltimetype tt);

/* create a time from an ISO format string */
struct icaltimetype icaltime_from_string(const char* str);

/* Routines for handling timezones */
/* Return a null time, which indicates no time has been set. This time represent the beginning of the epoch */
struct icaltimetype icaltime_null_time(void);

/* Return true of the time is null. */
int icaltime_is_null_time(struct icaltimetype t);

/* Returns false if the time is clearly invalid, but is not null. This
   is usually the result of creating a new time type buy not clearing
   it, or setting one of the flags to an illegal value. */
int icaltime_is_valid_time(struct icaltimetype t);

/** @brief Return the timezone */
const icaltimezone *icaltime_get_timezone(const struct icaltimetype t);

/** @brief Return the tzid, or NULL for a floating time */
char *icaltime_get_tzid(const struct icaltimetype t);

/** @brief Set the timezone */
struct icaltimetype icaltime_set_timezone(struct icaltimetype *t,
        const icaltimezone *zone);

/* Returns true if time is of DATE type, false if DATE-TIME */
int icaltime_is_date(struct icaltimetype t);

/* Returns true if time is relative to UTC zone */
int icaltime_is_utc(struct icaltimetype t);

/* Reset all of the time components to be in their normal ranges. For
   instance, given a time with minutes=70, the minutes will be reduces
   to 10, and the hour incremented. This allows the caller to do
   arithmetic on times without worrying about overflow or
   underflow. */
struct icaltimetype icaltime_normalize(struct icaltimetype t);

/* Return the day of the year of the given time */
short icaltime_day_of_year(struct icaltimetype t);

/* Create a new time, given a day of year and a year. */
struct icaltimetype icaltime_from_day_of_year(short doy,  short year);

/* Return the day of the week of the given time. Sunday is 0 */
short icaltime_day_of_week(struct icaltimetype t);

/* Return the day of the year for the Sunday of the week that the
   given time is within. */
short icaltime_start_doy_of_week(struct icaltimetype t);

/* Return the week number for the week the given time is within */
short icaltime_week_number(struct icaltimetype t);

/* Return -1, 0, or 1 to indicate that a<b, a==b or a>b */
int icaltime_compare(struct icaltimetype a,struct icaltimetype b);

/* like icaltime_compare, but only use the date parts. */
int icaltime_compare_date_only(struct icaltimetype a, struct icaltimetype b);

/* Return the number of days in the given month */
short icaltime_days_in_month(short month,short year);

/** convert tt, of timezone tzid, into a utc time. Does nothing if the
   time is already UTC.  */
struct icaltimetype icaltime_convert_to_zone(struct icaltimetype tt,
           icaltimezone *zone);



/***********************************************************************
  Duration Routines 
***********************************************************************/


struct icaldurationtype
{
	int is_neg;
	unsigned int days;
	unsigned int weeks;
	unsigned int hours;
	unsigned int minutes;
	unsigned int seconds;
};

struct icaldurationtype icaldurationtype_from_int(int t);
struct icaldurationtype icaldurationtype_from_string(const char*);
int icaldurationtype_as_int(struct icaldurationtype duration);
char* icaldurationtype_as_ical_string(struct icaldurationtype d);
struct icaldurationtype icaldurationtype_null_duration();
int icaldurationtype_is_null_duration(struct icaldurationtype d);

struct icaltimetype  icaltime_add(struct icaltimetype t,
				  struct icaldurationtype  d);

struct icaldurationtype  icaltime_subtract(struct icaltimetype t1,
					   struct icaltimetype t2);


/***********************************************************************
  Period Routines 
***********************************************************************/


struct icalperiodtype 
{
	struct icaltimetype start;
	struct icaltimetype end;
	struct icaldurationtype duration;
};

struct icalperiodtype icalperiodtype_from_string (const char* str);

const char* icalperiodtype_as_ical_string(struct icalperiodtype p);
struct icalperiodtype icalperiodtype_null_period();
int icalperiodtype_is_null_period(struct icalperiodtype p);
int icalperiodtype_is_valid_period(struct icalperiodtype p);

/***********************************************************************
 * timezone handling routines
***********************************************************************/

/** Returns a single builtin timezone, given its Olson city name. */
icaltimezone* icaltimezone_get_builtin_timezone	(const char *location);

/** Returns the UTC timezone. */
icaltimezone* icaltimezone_get_utc_timezone	(void);

/***********************************************************************
  Storage Routines
***********************************************************************/

/** 
 * @brief options for opening an icalfileset.
 *
 * These options should be passed to the icalset_new() function
 */

struct icalfileset_options {
  int          flags;		/**< flags for open() O_RDONLY, etc  */
  mode_t       mode;		/**< file mode */
  icalcluster  *cluster;	/**< use this cluster to initialize data */
};

icalset* icalfileset_new(const char* path);
icalset* icalfileset_new_reader(const char* path);
icalset* icalfileset_new_writer(const char* path);

icalset* icalfileset_init(icalset *set, const char *dsn, void* options);

/* icalfileset* icalfileset_new_from_cluster(const char* path, icalcluster *cluster); */

icalcluster* icalfileset_produce_icalcluster(const char *path);

void icalfileset_free(icalset* cluster);

const char* icalfileset_path(icalset* cluster);

/* Mark the cluster as changed, so it will be written to disk when it
   is freed. Commit writes to disk immediately. */
void icalfileset_mark(icalset* set);
icalerrorenum icalfileset_commit(icalset* set); 

icalerrorenum icalfileset_add_component(icalset* set,
					icalcomponent* child);

icalerrorenum icalfileset_remove_component(icalset* set,
					   icalcomponent* child);

int icalfileset_count_components(icalset* set,
				 int kind);

/**
 * Restrict the component returned by icalfileset_first, _next to those
 * that pass the gauge. _clear removes the gauge 
 */
icalerrorenum icalfileset_select(icalset* set, icalgauge* gauge);

/** clear the gauge **/
void icalfileset_clear(icalset* set);

/** Get and search for a component by uid **/
icalcomponent* icalfileset_fetch(icalset* set, const char* uid);
int icalfileset_has_uid(icalset* set, const char* uid);
icalcomponent* icalfileset_fetch_match(icalset* set, icalcomponent *c);


/**
 *  Modify components according to the MODIFY method of CAP. Works on the
 *  currently selected components. 
 */
icalerrorenum icalfileset_modify(icalset* set, 
				 icalcomponent *oldcomp,
			       icalcomponent *newcomp);

/* Iterate through components. If a gauge has been defined, these
   will skip over components that do not pass the gauge */

icalcomponent* icalfileset_get_current_component (icalset* cluster);
icalcomponent* icalfileset_get_first_component(icalset* cluster);
icalcomponent* icalfileset_get_next_component(icalset* cluster);

/* External iterator for thread safety */
icalsetiter icalfileset_begin_component(icalset* set, int kind, icalgauge* gauge);
icalcomponent * icalfilesetiter_to_next(icalset* set, icalsetiter *iter);
icalcomponent* icalfileset_form_a_matched_recurrence_component(icalsetiter* itr);

/***********************************************************************
  Gauge Routines
***********************************************************************/

icalgauge* icalgauge_new_from_sql(char* sql, int expand);

int icalgauge_get_expand(icalgauge* gauge);

void icalgauge_free(icalgauge* gauge);

/* Pending Implementation */
/* char* icalgauge_as_sql(icalcomponent* gauge); */

void icalgauge_dump(icalgauge* gauge);


/** @brief Return true if comp matches the gauge.
 *
 * The component must be in
 * cannonical form -- a VCALENDAR with one VEVENT, VTODO or VJOURNAL
 * sub component 
 */
int icalgauge_compare(icalgauge* g, icalcomponent* comp);

/* Pending Implementation */
/** Clone the component, but only return the properties 
 *  specified in the gauge */
/* icalcomponent* icalgauge_new_clone(icalgauge* g, icalcomponent* comp); */


/* Get by type */

 /* QUERY */ 
icalvalue* icalvalue_new_query(const char* v); 
const char* icalvalue_get_query(const icalvalue* value); 
void icalvalue_set_query(icalvalue* value, const char* v);


 /* DATE */ 
icalvalue* icalvalue_new_date(struct icaltimetype v); 
struct icaltimetype icalvalue_get_date(const icalvalue* value); 
void icalvalue_set_date(icalvalue* value, struct icaltimetype v);


 /* GEO */ 
icalvalue* icalvalue_new_geo(struct icalgeotype v); 
struct icalgeotype icalvalue_get_geo(const icalvalue* value); 
void icalvalue_set_geo(icalvalue* value, struct icalgeotype v);


 /* STATUS */ 
icalvalue* icalvalue_new_status(enum icalproperty_status v); 
enum icalproperty_status icalvalue_get_status(const icalvalue* value); 
void icalvalue_set_status(icalvalue* value, enum icalproperty_status v);


 /* TRANSP */ 
icalvalue* icalvalue_new_transp(enum icalproperty_transp v); 
enum icalproperty_transp icalvalue_get_transp(const icalvalue* value); 
void icalvalue_set_transp(icalvalue* value, enum icalproperty_transp v);


 /* STRING */ 
icalvalue* icalvalue_new_string(const char* v); 
const char* icalvalue_get_string(const icalvalue* value); 
void icalvalue_set_string(icalvalue* value, const char* v);


 /* TEXT */ 
icalvalue* icalvalue_new_text(const char* v); 
const char* icalvalue_get_text(const icalvalue* value); 
void icalvalue_set_text(icalvalue* value, const char* v);


 /* REQUEST-STATUS */ 
icalvalue* icalvalue_new_requeststatus(struct icalreqstattype v); 
struct icalreqstattype icalvalue_get_requeststatus(const icalvalue* value); 
void icalvalue_set_requeststatus(icalvalue* value, struct icalreqstattype v);


 /* CMD */ 
icalvalue* icalvalue_new_cmd(enum icalproperty_cmd v); 
enum icalproperty_cmd icalvalue_get_cmd(const icalvalue* value); 
void icalvalue_set_cmd(icalvalue* value, enum icalproperty_cmd v);


 /* BINARY */ 
icalvalue* icalvalue_new_binary(const char* v); 
const char* icalvalue_get_binary(const icalvalue* value); 
void icalvalue_set_binary(icalvalue* value, const char* v);


 /* QUERY-LEVEL */ 
icalvalue* icalvalue_new_querylevel(enum icalproperty_querylevel v); 
enum icalproperty_querylevel icalvalue_get_querylevel(const icalvalue* value); 
void icalvalue_set_querylevel(icalvalue* value, enum icalproperty_querylevel v);


 /* PERIOD */ 
icalvalue* icalvalue_new_period(struct icalperiodtype v); 
struct icalperiodtype icalvalue_get_period(const icalvalue* value); 
void icalvalue_set_period(icalvalue* value, struct icalperiodtype v);


 /* FLOAT */ 
icalvalue* icalvalue_new_float(float v); 
float icalvalue_get_float(const icalvalue* value); 
void icalvalue_set_float(icalvalue* value, float v);


 /* CAR-LEVEL */ 
icalvalue* icalvalue_new_carlevel(enum icalproperty_carlevel v); 
enum icalproperty_carlevel icalvalue_get_carlevel(const icalvalue* value); 
void icalvalue_set_carlevel(icalvalue* value, enum icalproperty_carlevel v);


 /* INTEGER */ 
icalvalue* icalvalue_new_integer(int v); 
int icalvalue_get_integer(const icalvalue* value); 
void icalvalue_set_integer(icalvalue* value, int v);


 /* CLASS */ 
icalvalue* icalvalue_new_class(enum icalproperty_class v); 
enum icalproperty_class icalvalue_get_class(const icalvalue* value); 
void icalvalue_set_class(icalvalue* value, enum icalproperty_class v);


 /* URI */ 
icalvalue* icalvalue_new_uri(const char* v); 
const char* icalvalue_get_uri(const icalvalue* value); 
void icalvalue_set_uri(icalvalue* value, const char* v);


 /* DURATION */ 
icalvalue* icalvalue_new_duration(struct icaldurationtype v); 
struct icaldurationtype icalvalue_get_duration(const icalvalue* value); 
void icalvalue_set_duration(icalvalue* value, struct icaldurationtype v);


 /* BOOLEAN */ 
icalvalue* icalvalue_new_boolean(int v); 
int icalvalue_get_boolean(const icalvalue* value); 
void icalvalue_set_boolean(icalvalue* value, int v);


 /* CAL-ADDRESS */ 
icalvalue* icalvalue_new_caladdress(const char* v); 
const char* icalvalue_get_caladdress(const icalvalue* value); 
void icalvalue_set_caladdress(icalvalue* value, const char* v);


 /* X-LIC-CLASS */ 
icalvalue* icalvalue_new_xlicclass(enum icalproperty_xlicclass v); 
enum icalproperty_xlicclass icalvalue_get_xlicclass(const icalvalue* value); 
void icalvalue_set_xlicclass(icalvalue* value, enum icalproperty_xlicclass v);


 /* ACTION */ 
icalvalue* icalvalue_new_action(enum icalproperty_action v); 
enum icalproperty_action icalvalue_get_action(const icalvalue* value); 
void icalvalue_set_action(icalvalue* value, enum icalproperty_action v);


 /* DATE-TIME */ 
icalvalue* icalvalue_new_datetime(struct icaltimetype v); 
struct icaltimetype icalvalue_get_datetime(const icalvalue* value); 
void icalvalue_set_datetime(icalvalue* value, struct icaltimetype v);


 /* UTC-OFFSET */ 
icalvalue* icalvalue_new_utcoffset(int v); 
int icalvalue_get_utcoffset(const icalvalue* value); 
void icalvalue_set_utcoffset(icalvalue* value, int v);


 /* METHOD */ 
icalvalue* icalvalue_new_method(enum icalproperty_method v); 
enum icalproperty_method icalvalue_get_method(const icalvalue* value); 
void icalvalue_set_method(icalvalue* value, enum icalproperty_method v);

/***********************************************************************
 * Component enumerations
**********************************************************************/

enum icalcomponent_kind {
    ICAL_NO_COMPONENT,
    ICAL_ANY_COMPONENT,	/* Used to select all components*/
    ICAL_XROOT_COMPONENT,
    ICAL_XATTACH_COMPONENT, /* MIME attached data, returned by parser. */
    ICAL_VEVENT_COMPONENT,
    ICAL_VTODO_COMPONENT,
    ICAL_VJOURNAL_COMPONENT,
    ICAL_VCALENDAR_COMPONENT,
    ICAL_VAGENDA_COMPONENT,
    ICAL_VFREEBUSY_COMPONENT,
    ICAL_VALARM_COMPONENT,
    ICAL_XAUDIOALARM_COMPONENT,  
    ICAL_XDISPLAYALARM_COMPONENT,
    ICAL_XEMAILALARM_COMPONENT,
    ICAL_XPROCEDUREALARM_COMPONENT,
    ICAL_VTIMEZONE_COMPONENT,
    ICAL_XSTANDARD_COMPONENT,
    ICAL_XDAYLIGHT_COMPONENT,
    ICAL_X_COMPONENT,
    ICAL_VSCHEDULE_COMPONENT,
    ICAL_VQUERY_COMPONENT,
    ICAL_VREPLY_COMPONENT,
    ICAL_VCAR_COMPONENT,
    ICAL_VCOMMAND_COMPONENT,
    ICAL_XLICINVALID_COMPONENT,
    ICAL_XLICMIMEPART_COMPONENT /* a non-stardard component that mirrors
				structure of MIME data */

};

/***********************************************************************
 * Request Status codes
 **********************************************************************/

enum icalrequeststatus {
    ICAL_UNKNOWN_STATUS,
    ICAL_2_0_SUCCESS_STATUS,
    ICAL_2_1_FALLBACK_STATUS,
    ICAL_2_2_IGPROP_STATUS,
    ICAL_2_3_IGPARAM_STATUS,
    ICAL_2_4_IGXPROP_STATUS,
    ICAL_2_5_IGXPARAM_STATUS,
    ICAL_2_6_IGCOMP_STATUS,
    ICAL_2_7_FORWARD_STATUS,
    ICAL_2_8_ONEEVENT_STATUS,
    ICAL_2_9_TRUNC_STATUS,
    ICAL_2_10_ONETODO_STATUS,
    ICAL_2_11_TRUNCRRULE_STATUS,
    ICAL_3_0_INVPROPNAME_STATUS,
    ICAL_3_1_INVPROPVAL_STATUS,
    ICAL_3_2_INVPARAM_STATUS,
    ICAL_3_3_INVPARAMVAL_STATUS,
    ICAL_3_4_INVCOMP_STATUS,
    ICAL_3_5_INVTIME_STATUS,
    ICAL_3_6_INVRULE_STATUS,
    ICAL_3_7_INVCU_STATUS,
    ICAL_3_8_NOAUTH_STATUS,
    ICAL_3_9_BADVERSION_STATUS,
    ICAL_3_10_TOOBIG_STATUS,
    ICAL_3_11_MISSREQCOMP_STATUS,
    ICAL_3_12_UNKCOMP_STATUS,
    ICAL_3_13_BADCOMP_STATUS,
    ICAL_3_14_NOCAP_STATUS,
    ICAL_3_15_INVCOMMAND,
    ICAL_4_0_BUSY_STATUS,
    ICAL_4_1_STORE_ACCESS_DENIED,
    ICAL_4_2_STORE_FAILED,
    ICAL_4_3_STORE_NOT_FOUND,
    ICAL_5_0_MAYBE_STATUS,
    ICAL_5_1_UNAVAIL_STATUS,
    ICAL_5_2_NOSERVICE_STATUS,
    ICAL_5_3_NOSCHED_STATUS,
    ICAL_6_1_CONTAINER_NOT_FOUND,
	ICAL_9_0_UNRECOGNIZED_COMMAND
};

/*
 * Recurrance enumerations
 */

enum icalrecurrencetype_frequency
{
    /* These enums are used to index an array, so don't change the
       order or the integers */

    ICAL_SECONDLY_RECURRENCE=0,
    ICAL_MINUTELY_RECURRENCE=1,
    ICAL_HOURLY_RECURRENCE=2,
    ICAL_DAILY_RECURRENCE=3,
    ICAL_WEEKLY_RECURRENCE=4,
    ICAL_MONTHLY_RECURRENCE=5,
    ICAL_YEARLY_RECURRENCE=6,
    ICAL_NO_RECURRENCE=7

};

enum icalrecurrencetype_weekday
{
    ICAL_NO_WEEKDAY,
    ICAL_SUNDAY_WEEKDAY,
    ICAL_MONDAY_WEEKDAY,
    ICAL_TUESDAY_WEEKDAY,
    ICAL_WEDNESDAY_WEEKDAY,
    ICAL_THURSDAY_WEEKDAY,
    ICAL_FRIDAY_WEEKDAY,
    ICAL_SATURDAY_WEEKDAY
};

enum icalvalue_kind {
   ICAL_ANY_VALUE=5000,
    ICAL_QUERY_VALUE=5001,
    ICAL_DATE_VALUE=5002,
    ICAL_ATTACH_VALUE=5003,
    ICAL_GEO_VALUE=5004,
    ICAL_STATUS_VALUE=5005,
    ICAL_TRANSP_VALUE=5006,
    ICAL_STRING_VALUE=5007,
    ICAL_TEXT_VALUE=5008,
    ICAL_REQUESTSTATUS_VALUE=5009,
    ICAL_CMD_VALUE=5010,
    ICAL_BINARY_VALUE=5011,
    ICAL_QUERYLEVEL_VALUE=5012,
    ICAL_PERIOD_VALUE=5013,
    ICAL_FLOAT_VALUE=5014,
    ICAL_DATETIMEPERIOD_VALUE=5015,
    ICAL_CARLEVEL_VALUE=5016,
    ICAL_INTEGER_VALUE=5017,
    ICAL_CLASS_VALUE=5018,
    ICAL_URI_VALUE=5019,
    ICAL_DURATION_VALUE=5020,
    ICAL_BOOLEAN_VALUE=5021,
    ICAL_X_VALUE=5022,
    ICAL_CALADDRESS_VALUE=5023,
    ICAL_TRIGGER_VALUE=5024,
    ICAL_XLICCLASS_VALUE=5025,
    ICAL_RECUR_VALUE=5026,
    ICAL_ACTION_VALUE=5027,
    ICAL_DATETIME_VALUE=5028,
    ICAL_UTCOFFSET_VALUE=5029,
    ICAL_METHOD_VALUE=5030,
   ICAL_NO_VALUE=5031
};

enum icalproperty_action {
    ICAL_ACTION_X = 10000,
    ICAL_ACTION_AUDIO = 10001,
    ICAL_ACTION_DISPLAY = 10002,
    ICAL_ACTION_EMAIL = 10003,
    ICAL_ACTION_PROCEDURE = 10004,
    ICAL_ACTION_NONE = 10005
};

enum icalproperty_carlevel {
    ICAL_CARLEVEL_X = 10006,
    ICAL_CARLEVEL_CARNONE = 10007,
    ICAL_CARLEVEL_CARMIN = 10008,
    ICAL_CARLEVEL_CARFULL1 = 10009,
    ICAL_CARLEVEL_NONE = 10010
};

enum icalproperty_class {
    ICAL_CLASS_X = 10011,
    ICAL_CLASS_PUBLIC = 10012,
    ICAL_CLASS_PRIVATE = 10013,
    ICAL_CLASS_CONFIDENTIAL = 10014,
    ICAL_CLASS_NONE = 10015
};

enum icalproperty_cmd {
    ICAL_CMD_X = 10016,
    ICAL_CMD_ABORT = 10017,
    ICAL_CMD_CONTINUE = 10018,
    ICAL_CMD_CREATE = 10019,
    ICAL_CMD_DELETE = 10020,
    ICAL_CMD_GENERATEUID = 10021,
    ICAL_CMD_GETCAPABILITY = 10022,
    ICAL_CMD_IDENTIFY = 10023,
    ICAL_CMD_MODIFY = 10024,
    ICAL_CMD_MOVE = 10025,
    ICAL_CMD_REPLY = 10026,
    ICAL_CMD_SEARCH = 10027,
    ICAL_CMD_SETLOCALE = 10028,
    ICAL_CMD_NONE = 10029
};

enum icalproperty_method {
    ICAL_METHOD_X = 10030,
    ICAL_METHOD_PUBLISH = 10031,
    ICAL_METHOD_REQUEST = 10032,
    ICAL_METHOD_REPLY = 10033,
    ICAL_METHOD_ADD = 10034,
    ICAL_METHOD_CANCEL = 10035,
    ICAL_METHOD_REFRESH = 10036,
    ICAL_METHOD_COUNTER = 10037,
    ICAL_METHOD_DECLINECOUNTER = 10038,
    ICAL_METHOD_CREATE = 10039,
    ICAL_METHOD_READ = 10040,
    ICAL_METHOD_RESPONSE = 10041,
    ICAL_METHOD_MOVE = 10042,
    ICAL_METHOD_MODIFY = 10043,
    ICAL_METHOD_GENERATEUID = 10044,
    ICAL_METHOD_DELETE = 10045,
    ICAL_METHOD_NONE = 10046
};

enum icalproperty_querylevel {
    ICAL_QUERYLEVEL_X = 10047,
    ICAL_QUERYLEVEL_CALQL1 = 10048,
    ICAL_QUERYLEVEL_CALQLNONE = 10049,
    ICAL_QUERYLEVEL_NONE = 10050
};

enum icalproperty_status {
    ICAL_STATUS_X = 10051,
    ICAL_STATUS_TENTATIVE = 10052,
    ICAL_STATUS_CONFIRMED = 10053,
    ICAL_STATUS_COMPLETED = 10054,
    ICAL_STATUS_NEEDSACTION = 10055,
    ICAL_STATUS_CANCELLED = 10056,
    ICAL_STATUS_INPROCESS = 10057,
    ICAL_STATUS_DRAFT = 10058,
    ICAL_STATUS_FINAL = 10059,
    ICAL_STATUS_NONE = 10060
};

enum icalproperty_transp {
    ICAL_TRANSP_X = 10061,
    ICAL_TRANSP_OPAQUE = 10062,
    ICAL_TRANSP_OPAQUENOCONFLICT = 10063,
    ICAL_TRANSP_TRANSPARENT = 10064,
    ICAL_TRANSP_TRANSPARENTNOCONFLICT = 10065,
    ICAL_TRANSP_NONE = 10066
};

enum icalproperty_xlicclass {
    ICAL_XLICCLASS_X = 10067,
    ICAL_XLICCLASS_PUBLISHNEW = 10068,
    ICAL_XLICCLASS_PUBLISHUPDATE = 10069,
    ICAL_XLICCLASS_PUBLISHFREEBUSY = 10070,
    ICAL_XLICCLASS_REQUESTNEW = 10071,
    ICAL_XLICCLASS_REQUESTUPDATE = 10072,
    ICAL_XLICCLASS_REQUESTRESCHEDULE = 10073,
    ICAL_XLICCLASS_REQUESTDELEGATE = 10074,
    ICAL_XLICCLASS_REQUESTNEWORGANIZER = 10075,
    ICAL_XLICCLASS_REQUESTFORWARD = 10076,
    ICAL_XLICCLASS_REQUESTSTATUS = 10077,
    ICAL_XLICCLASS_REQUESTFREEBUSY = 10078,
    ICAL_XLICCLASS_REPLYACCEPT = 10079,
    ICAL_XLICCLASS_REPLYDECLINE = 10080,
    ICAL_XLICCLASS_REPLYDELEGATE = 10081,
    ICAL_XLICCLASS_REPLYCRASHERACCEPT = 10082,
    ICAL_XLICCLASS_REPLYCRASHERDECLINE = 10083,
    ICAL_XLICCLASS_ADDINSTANCE = 10084,
    ICAL_XLICCLASS_CANCELEVENT = 10085,
    ICAL_XLICCLASS_CANCELINSTANCE = 10086,
    ICAL_XLICCLASS_CANCELALL = 10087,
    ICAL_XLICCLASS_REFRESH = 10088,
    ICAL_XLICCLASS_COUNTER = 10089,
    ICAL_XLICCLASS_DECLINECOUNTER = 10090,
    ICAL_XLICCLASS_MALFORMED = 10091,
    ICAL_XLICCLASS_OBSOLETE = 10092,
    ICAL_XLICCLASS_MISSEQUENCED = 10093,
    ICAL_XLICCLASS_UNKNOWN = 10094,
    ICAL_XLICCLASS_NONE = 10095
};

enum icalparameter_kind {
    ICAL_ANY_PARAMETER = 0,
    ICAL_ACTIONPARAM_PARAMETER, 
    ICAL_ALTREP_PARAMETER, 
    ICAL_CHARSET_PARAMETER, 
    ICAL_CN_PARAMETER, 
    ICAL_CUTYPE_PARAMETER, 
    ICAL_DELEGATEDFROM_PARAMETER, 
    ICAL_DELEGATEDTO_PARAMETER, 
    ICAL_DIR_PARAMETER, 
    ICAL_ENABLE_PARAMETER, 
    ICAL_ENCODING_PARAMETER, 
    ICAL_FBTYPE_PARAMETER, 
    ICAL_FMTTYPE_PARAMETER, 
    ICAL_ID_PARAMETER, 
    ICAL_LANGUAGE_PARAMETER, 
    ICAL_LATENCY_PARAMETER, 
    ICAL_LOCAL_PARAMETER, 
    ICAL_LOCALIZE_PARAMETER, 
    ICAL_MEMBER_PARAMETER, 
    ICAL_OPTIONS_PARAMETER, 
    ICAL_PARTSTAT_PARAMETER, 
    ICAL_RANGE_PARAMETER, 
    ICAL_RELATED_PARAMETER, 
    ICAL_RELTYPE_PARAMETER, 
    ICAL_ROLE_PARAMETER, 
    ICAL_RSVP_PARAMETER, 
    ICAL_SENTBY_PARAMETER, 
    ICAL_TZID_PARAMETER, 
    ICAL_VALUE_PARAMETER, 
    ICAL_X_PARAMETER, 
    ICAL_XLICCOMPARETYPE_PARAMETER, 
    ICAL_XLICERRORTYPE_PARAMETER, 
    ICAL_NO_PARAMETER
};

enum icalparameter_action {
    ICAL_ACTIONPARAM_X = 20000,
    ICAL_ACTIONPARAM_ASK = 20001,
    ICAL_ACTIONPARAM_ABORT = 20002,
    ICAL_ACTIONPARAM_NONE = 20003
};

enum icalparameter_cutype {
    ICAL_CUTYPE_X = 20004,
    ICAL_CUTYPE_INDIVIDUAL = 20005,
    ICAL_CUTYPE_GROUP = 20006,
    ICAL_CUTYPE_RESOURCE = 20007,
    ICAL_CUTYPE_ROOM = 20008,
    ICAL_CUTYPE_UNKNOWN = 20009,
    ICAL_CUTYPE_NONE = 20010
};

enum icalparameter_enable {
    ICAL_ENABLE_X = 20011,
    ICAL_ENABLE_TRUE = 20012,
    ICAL_ENABLE_FALSE = 20013,
    ICAL_ENABLE_NONE = 20014
};

enum icalparameter_encoding {
    ICAL_ENCODING_X = 20015,
    ICAL_ENCODING_8BIT = 20016,
    ICAL_ENCODING_BASE64 = 20017,
    ICAL_ENCODING_NONE = 20018
};

enum icalparameter_fbtype {
    ICAL_FBTYPE_X = 20019,
    ICAL_FBTYPE_FREE = 20020,
    ICAL_FBTYPE_BUSY = 20021,
    ICAL_FBTYPE_BUSYUNAVAILABLE = 20022,
    ICAL_FBTYPE_BUSYTENTATIVE = 20023,
    ICAL_FBTYPE_NONE = 20024
};

enum icalparameter_local {
    ICAL_LOCAL_X = 20025,
    ICAL_LOCAL_TRUE = 20026,
    ICAL_LOCAL_FALSE = 20027,
    ICAL_LOCAL_NONE = 20028
};

enum icalparameter_partstat {
    ICAL_PARTSTAT_X = 20029,
    ICAL_PARTSTAT_NEEDSACTION = 20030,
    ICAL_PARTSTAT_ACCEPTED = 20031,
    ICAL_PARTSTAT_DECLINED = 20032,
    ICAL_PARTSTAT_TENTATIVE = 20033,
    ICAL_PARTSTAT_DELEGATED = 20034,
    ICAL_PARTSTAT_COMPLETED = 20035,
    ICAL_PARTSTAT_INPROCESS = 20036,
    ICAL_PARTSTAT_NONE = 20037
};

enum icalparameter_range {
    ICAL_RANGE_X = 20038,
    ICAL_RANGE_THISANDPRIOR = 20039,
    ICAL_RANGE_THISANDFUTURE = 20040,
    ICAL_RANGE_NONE = 20041
};

enum icalparameter_related {
    ICAL_RELATED_X = 20042,
    ICAL_RELATED_START = 20043,
    ICAL_RELATED_END = 20044,
    ICAL_RELATED_NONE = 20045
};

enum icalparameter_reltype {
    ICAL_RELTYPE_X = 20046,
    ICAL_RELTYPE_PARENT = 20047,
    ICAL_RELTYPE_CHILD = 20048,
    ICAL_RELTYPE_SIBLING = 20049,
    ICAL_RELTYPE_NONE = 20050
};

enum icalparameter_role {
    ICAL_ROLE_X = 20051,
    ICAL_ROLE_CHAIR = 20052,
    ICAL_ROLE_REQPARTICIPANT = 20053,
    ICAL_ROLE_OPTPARTICIPANT = 20054,
    ICAL_ROLE_NONPARTICIPANT = 20055,
    ICAL_ROLE_NONE = 20056
};

enum icalparameter_rsvp {
    ICAL_RSVP_X = 20057,
    ICAL_RSVP_TRUE = 20058,
    ICAL_RSVP_FALSE = 20059,
    ICAL_RSVP_NONE = 20060
};

enum icalparameter_value {
    ICAL_VALUE_X = 20061,
    ICAL_VALUE_BINARY = 20062,
    ICAL_VALUE_BOOLEAN = 20063,
    ICAL_VALUE_DATE = 20064,
    ICAL_VALUE_DURATION = 20065,
    ICAL_VALUE_FLOAT = 20066,
    ICAL_VALUE_INTEGER = 20067,
    ICAL_VALUE_PERIOD = 20068,
    ICAL_VALUE_RECUR = 20069,
    ICAL_VALUE_TEXT = 20070,
    ICAL_VALUE_URI = 20071,
    ICAL_VALUE_ERROR = 20072,
    ICAL_VALUE_DATETIME = 20073,
    ICAL_VALUE_UTCOFFSET = 20074,
    ICAL_VALUE_CALADDRESS = 20075,
    ICAL_VALUE_NONE = 20076
};

enum icalparameter_xliccomparetype {
    ICAL_XLICCOMPARETYPE_X = 20077,
    ICAL_XLICCOMPARETYPE_EQUAL = 20078,
    ICAL_XLICCOMPARETYPE_NOTEQUAL = 20079,
    ICAL_XLICCOMPARETYPE_LESS = 20080,
    ICAL_XLICCOMPARETYPE_GREATER = 20081,
    ICAL_XLICCOMPARETYPE_LESSEQUAL = 20082,
    ICAL_XLICCOMPARETYPE_GREATEREQUAL = 20083,
    ICAL_XLICCOMPARETYPE_REGEX = 20084,
    ICAL_XLICCOMPARETYPE_ISNULL = 20085,
    ICAL_XLICCOMPARETYPE_ISNOTNULL = 20086,
    ICAL_XLICCOMPARETYPE_NONE = 20087
};

enum icalparameter_xlicerrortype {
    ICAL_XLICERRORTYPE_X = 20088,
    ICAL_XLICERRORTYPE_COMPONENTPARSEERROR = 20089,
    ICAL_XLICERRORTYPE_PROPERTYPARSEERROR = 20090,
    ICAL_XLICERRORTYPE_PARAMETERNAMEPARSEERROR = 20091,
    ICAL_XLICERRORTYPE_PARAMETERVALUEPARSEERROR = 20092,
    ICAL_XLICERRORTYPE_VALUEPARSEERROR = 20093,
    ICAL_XLICERRORTYPE_INVALIDITIP = 20094,
    ICAL_XLICERRORTYPE_UNKNOWNVCALPROPERROR = 20095,
    ICAL_XLICERRORTYPE_MIMEPARSEERROR = 20096,
    ICAL_XLICERRORTYPE_VCALPROPPARSEERROR = 20097,
    ICAL_XLICERRORTYPE_NONE = 20098
};

enum icalproperty_kind {
    ICAL_ANY_PROPERTY = 0,
    ICAL_ACTION_PROPERTY, 
    ICAL_ALLOWCONFLICT_PROPERTY, 
    ICAL_ATTACH_PROPERTY, 
    ICAL_ATTENDEE_PROPERTY, 
    ICAL_CALID_PROPERTY, 
    ICAL_CALMASTER_PROPERTY, 
    ICAL_CALSCALE_PROPERTY, 
    ICAL_CAPVERSION_PROPERTY, 
    ICAL_CARLEVEL_PROPERTY, 
    ICAL_CARID_PROPERTY, 
    ICAL_CATEGORIES_PROPERTY, 
    ICAL_CLASS_PROPERTY, 
    ICAL_CMD_PROPERTY, 
    ICAL_COMMENT_PROPERTY, 
    ICAL_COMPLETED_PROPERTY, 
    ICAL_COMPONENTS_PROPERTY, 
    ICAL_CONTACT_PROPERTY, 
    ICAL_CREATED_PROPERTY, 
    ICAL_CSID_PROPERTY, 
    ICAL_DATEMAX_PROPERTY, 
    ICAL_DATEMIN_PROPERTY, 
    ICAL_DECREED_PROPERTY, 
    ICAL_DEFAULTCHARSET_PROPERTY, 
    ICAL_DEFAULTLOCALE_PROPERTY, 
    ICAL_DEFAULTTZID_PROPERTY, 
    ICAL_DEFAULTVCARS_PROPERTY, 
    ICAL_DENY_PROPERTY, 
    ICAL_DESCRIPTION_PROPERTY, 
    ICAL_DTEND_PROPERTY, 
    ICAL_DTSTAMP_PROPERTY, 
    ICAL_DTSTART_PROPERTY, 
    ICAL_DUE_PROPERTY, 
    ICAL_DURATION_PROPERTY, 
    ICAL_EXDATE_PROPERTY, 
    ICAL_EXPAND_PROPERTY, 
    ICAL_EXRULE_PROPERTY, 
    ICAL_FREEBUSY_PROPERTY, 
    ICAL_GEO_PROPERTY, 
    ICAL_GRANT_PROPERTY, 
    ICAL_ITIPVERSION_PROPERTY, 
    ICAL_LASTMODIFIED_PROPERTY, 
    ICAL_LOCATION_PROPERTY, 
    ICAL_MAXCOMPONENTSIZE_PROPERTY, 
    ICAL_MAXDATE_PROPERTY, 
    ICAL_MAXRESULTS_PROPERTY, 
    ICAL_MAXRESULTSSIZE_PROPERTY, 
    ICAL_METHOD_PROPERTY, 
    ICAL_MINDATE_PROPERTY, 
    ICAL_MULTIPART_PROPERTY, 
    ICAL_NAME_PROPERTY, 
    ICAL_ORGANIZER_PROPERTY, 
    ICAL_OWNER_PROPERTY, 
    ICAL_PERCENTCOMPLETE_PROPERTY, 
    ICAL_PERMISSION_PROPERTY, 
    ICAL_PRIORITY_PROPERTY, 
    ICAL_PRODID_PROPERTY, 
    ICAL_QUERY_PROPERTY, 
    ICAL_QUERYLEVEL_PROPERTY, 
    ICAL_QUERYID_PROPERTY, 
    ICAL_QUERYNAME_PROPERTY, 
    ICAL_RDATE_PROPERTY, 
    ICAL_RECURACCEPTED_PROPERTY, 
    ICAL_RECUREXPAND_PROPERTY, 
    ICAL_RECURLIMIT_PROPERTY, 
    ICAL_RECURRENCEID_PROPERTY, 
    ICAL_RELATEDTO_PROPERTY, 
    ICAL_RELCALID_PROPERTY, 
    ICAL_REPEAT_PROPERTY, 
    ICAL_REQUESTSTATUS_PROPERTY, 
    ICAL_RESOURCES_PROPERTY, 
    ICAL_RESTRICTION_PROPERTY, 
    ICAL_RRULE_PROPERTY, 
    ICAL_SCOPE_PROPERTY, 
    ICAL_SEQUENCE_PROPERTY, 
    ICAL_STATUS_PROPERTY, 
    ICAL_STORESEXPANDED_PROPERTY, 
    ICAL_SUMMARY_PROPERTY, 
    ICAL_TARGET_PROPERTY, 
    ICAL_TRANSP_PROPERTY, 
    ICAL_TRIGGER_PROPERTY, 
    ICAL_TZID_PROPERTY, 
    ICAL_TZNAME_PROPERTY, 
    ICAL_TZOFFSETFROM_PROPERTY, 
    ICAL_TZOFFSETTO_PROPERTY, 
    ICAL_TZURL_PROPERTY, 
    ICAL_UID_PROPERTY, 
    ICAL_URL_PROPERTY, 
    ICAL_VERSION_PROPERTY, 
    ICAL_X_PROPERTY, 
    ICAL_XLICCLASS_PROPERTY, 
    ICAL_XLICCLUSTERCOUNT_PROPERTY, 
    ICAL_XLICERROR_PROPERTY, 
    ICAL_XLICMIMECHARSET_PROPERTY, 
    ICAL_XLICMIMECID_PROPERTY, 
    ICAL_XLICMIMECONTENTTYPE_PROPERTY, 
    ICAL_XLICMIMEENCODING_PROPERTY, 
    ICAL_XLICMIMEFILENAME_PROPERTY, 
    ICAL_XLICMIMEOPTINFO_PROPERTY, 
    ICAL_NO_PROPERTY
};

enum icalparser_state {
    ICALPARSER_ERROR,
    ICALPARSER_SUCCESS,
    ICALPARSER_BEGIN_COMP,
    ICALPARSER_END_COMP,
    ICALPARSER_IN_PROGRESS
};

enum icalerrorenum {
    ICAL_NO_ERROR,     /* icalerrno may not be initialized - put it first so and pray that the compiler initialize things to zero */    
    ICAL_BADARG_ERROR,
    ICAL_NEWFAILED_ERROR,
    ICAL_ALLOCATION_ERROR,
    ICAL_MALFORMEDDATA_ERROR, 
    ICAL_PARSE_ERROR,
    ICAL_INTERNAL_ERROR, /* Like assert --internal consist. prob */
    ICAL_FILE_ERROR,
    ICAL_USAGE_ERROR,
    ICAL_UNIMPLEMENTED_ERROR,
    ICAL_UNKNOWN_ERROR  /* Used for problems in input to icalerror_strerror()*/
};

enum icalerrorstate { 
    ICAL_ERROR_FATAL,     /* Not fata */
    ICAL_ERROR_NONFATAL,  /* Fatal */
    ICAL_ERROR_DEFAULT,   /* Use the value of icalerror_errors_are_fatal*/
    ICAL_ERROR_UNKNOWN    /* Asked state for an unknown error type */
};

enum icalrestriction_kind {
    ICAL_RESTRICTION_NONE=0,		/* 0 */
    ICAL_RESTRICTION_ZERO,		/* 1 */
    ICAL_RESTRICTION_ONE,		/* 2 */
    ICAL_RESTRICTION_ZEROPLUS,		/* 3 */
    ICAL_RESTRICTION_ONEPLUS,		/* 4 */
    ICAL_RESTRICTION_ZEROORONE,		/* 5 */
    ICAL_RESTRICTION_ONEEXCLUSIVE,	/* 6 */
    ICAL_RESTRICTION_ONEMUTUAL,		/* 7 */
    ICAL_RESTRICTION_UNKNOWN		/* 8 */
};
