#!/usr/bin/env ruby

# TODO Figure out how to access unknown properties, e.g. POSTALCODE in VVENUE

def display_component(component)
  puts "== #{component.kind || '!UNKNOWN!'} =="
  component.keys.each do |key|
    value = component[key]
    if value.kind_of?(Array)
      puts "- #{key} => "
      value.each do |node|
        puts "  . #{node}"
      end
    else
      puts "- #{key} => #{value}"
    end
  end
  puts
end

load 'icalagator.rb'
calendar = Icalagator.new(:file => '../../test-data/ical_upcoming.ics')
event, venue = calendar.components

display_component(event)
display_component(venue)
