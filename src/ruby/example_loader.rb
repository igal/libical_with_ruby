#!/usr/bin/env ruby

# SUMMARY: Simplest possible use of the paring library

require 'LibicalWrap'

# From http://en.wikipedia.org/wiki/ICalendar
ics = <<-HERE
BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VEVENT
DTSTART:19970714T170000Z
DTEND:19970715T035959Z
SUMMARY:Bastille Day Party
END:VEVENT
END:VCALENDAR
HERE

ics = File.read('../../test-data/2445.ics')

calendar = LibicalWrap.icalparser_parse_string(ics)
puts "* Parsed ics data and got: #{calendar.inspect}"
