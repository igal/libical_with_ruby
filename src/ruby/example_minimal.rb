#!/usr/bin/env ruby

load 'icalagator.rb'
root = Icalagator.new(:file => '../../test-data/2445.ics')
event = root.events.first

puts '* Summary: ' + event[:summary]
puts '* Categories: ' + event[:categories].join(', ')
puts '* Properties:'
event.properties.each do |property|
  puts "- #{property.key} => #{property.value}"
end

