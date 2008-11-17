#!/usr/bin/env python 
# -*- Mode: python -*-
#======================================================================
# FILE: Time.py
# CREATOR: eric 
#
# DESCRIPTION:
#   
#
#  $Id: Time.py,v 1.3 2002-07-12 08:02:46 acampi Exp $
#  $Locker:  $
#
# (C) COPYRIGHT 2001, Eric Busboom <eric@softwarestudio.org>
# (C) COPYRIGHT 2001, Patrick Lewis <plewis@inetarena.com>  
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of either: 
#
#    The LGPL as published by the Free Software Foundation, version
#    2.1, available at: http://www.fsf.org/copyleft/lesser.html
#
#  Or:
#
#    The Mozilla Public License Version 1.0. You may obtain a copy of
#    the License at http://www.mozilla.org/MPL/
#======================================================================

from LibicalWrap import *
from Property import Property
from types import DictType, StringType, IntType, FloatType
from Duration import Duration

class Time(Property):
    """ Represent iCalendar DATE, TIME and DATE-TIME """
    def __init__(self, arg, name="DTSTART", zone=None):
        """ 
        Create a new Time from a string or number of seconds past the 
        POSIX epoch

        Time("19970325T123000Z")  Construct from an iCalendar string
        Time(8349873494)          Construct from seconds past POSIX epoch
        
        """
        e1=icalerror_supress("MALFORMEDDATA")
        e2=icalerror_supress("BADARG")

        if isinstance(arg, DictType):
            # Dictionary -- used for creating from Component
            self.tt = icaltime_from_string(arg['value'])
            Property.__init__(self, ref=arg['ref'])
        else:
            if isinstance(arg, StringType):
                # Create from an iCal string
                self.tt = icaltime_from_string(arg)
            elif isinstance(arg, IntType) or   \
                 isinstance(arg, FloatType): 
                # Create from seconds past the POSIX epoch
		if zone:
                	self.tt = icaltime_from_timet_with_zone(int(arg),0,icaltimezone_get_builtin_timezone(zone))
		else:
                	self.tt = icaltime_from_timet_with_zone(int(arg),0,icaltimezone_get_utc_timezone())
            elif isinstance(arg, Time):
                # Copy an instance
                self.tt = arg.tt
            else:
                self.tt = icaltime_null_time()

            Property.__init__(self,type=name)

        icalerror_restore("MALFORMEDDATA",e1)
        icalerror_restore("BADARG",e2)

        if icaltime_is_null_time(self.tt):
            raise Property.ConstructorFailedError("Failed to construct a Time")

        try:
            self._update_value()
        except Property.UpdateFailedError:
            raise Property.ConstructorFailedError("Failed to construct a Time")

    def _update_value(self):
        self.tt = icaltime_normalize(self.tt)
        self.value(icaltime_as_ical_string(self.tt),"DATE-TIME")

    def valid(self):
        " Return true if this is a valid time "
        return not icaltime_is_null_time(self.tt)

    def utc_seconds(self,v=None):
        """ Return or set time in seconds past POSIX epoch"""
        if (v!=None):
	    tz = icaltimezone_get_builtin_timezone(self.timezone())
            self.tt = icaltime_from_timet_with_zone(v,0,tz)
            self._update_value()

        return icaltime_as_timet(self.tt)

    def is_utc(self):
        """ Return a boolean indicating if time is in UTC """
        return icaltime_is_utc(self.tt)

    def is_date(self):
        """ Return a boolean indicating if time is actually a date """
        return icaltime_is_date(self.tt)

    def timezone(self,v=None):
        """ Return, set (if none) or alter the timezone for this time """
	
	origtz = icaltime_get_tzid(self.tt)

	if (v != None):
            assert(isinstance(v,StringType) )
	    if (v == "UTC"):
                tz = icaltimezone_get_utc_timezone()
		del self['TZID']
            else:
	    	tz = icaltimezone_get_builtin_timezone(v)

            if not origtz:
	        self.tt = icaltime_set_timezone(self.tt, tz)
            else:
	        self.tt = icaltime_convert_to_zone(self.tt,tz)

	    if (icaltime_get_tzid(self.tt) != "UTC"):
            	self['TZID'] = icaltime_get_tzid(self.tt)

        self._update_value()
	return icaltime_get_tzid(self.tt)

    def second(self,v=None):
        """ Get or set the seconds component of this time """
        if(v != None):
            icaltimetype_second_set(self.tt,v)
            self._update_value()
        return icaltimetype_second_get(self.tt)

    def minute(self,v=None):
        """ Get or set the minute component of this time """
        if(v != None):
            icaltimetype_minute_set(self.tt,v)
            self._update_value()
        return icaltimetype_minute_get(self.tt)

    def hour(self,v=None):
        """ Get or set the hour component of this time """
        if(v != None):
            icaltimetype_hour_set(self.tt,v)
            self._update_value()
        return icaltimetype_hour_get(self.tt)

    def day(self,v=None):
        """ Get or set the month day component of this time """
        if(v != None):
            icaltimetype_day_set(self.tt,v)
            self._update_value()
        return icaltimetype_day_get(self.tt)

    def month(self,v=None):
        """ Get or set the month component of this time. January is month 1 """
        if(v != None):
            icaltimetype_month_set(self.tt,v)
            self._update_value()
        return icaltimetype_month_get(self.tt)

    def year(self,v=None):
        """ Get or set the year component of this time """
        if(v != None):
            icaltimetype_year_set(self.tt,v)
            self._update_value()

        return icaltimetype_year_get(self.tt)


    def __cmp__(self,other):

        if other == None:
            return cmp(self.utc_seconds(),None)

        return cmp(self.utc_seconds(),other.utc_seconds())


    def __add__(self,o):

        other = Duration(o,"DURATION")      

        if not other.valid():
            return Duration(0,"DURATION")
  
        seconds = self.utc_seconds() + other.seconds()
    
        new = Time(seconds,self.name(),self.timezone())

        return new

    def __radd_(self,o):
        return self.__add__(o)
    

    def __sub__(self,o):

        
        if isinstance(o,Time):
            # Subtract a time from this time and return a duration
            seconds = self.utc_seconds() - other.utc_seconds()
            return Duration(seconds)
        elif isinstance(o,Duration):
            # Subtract a duration from this time and return a time
            other = Duration(o)
            if(not other.valid()):
                return Time()

            seconds = self.utc_seconds() - other.seconds()
            return Time(seconds)
        else:
            raise TypeError, "subtraction with Time reqires Time or Duration"
