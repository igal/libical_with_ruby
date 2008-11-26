#!/usr/bin/env ruby

load 'icalagator.rb'

MAX_PROPERTY_LABEL_LENGTH = "LAST-MODIFIED".size

def display_component(component, parent=nil)
  puts %{* #{component.kind} -- #{parent ? "embedded component" : "top-level component"}#{component.components.size > 0 ? " with #{component.components.size} embedded components" : ""}}

  component.properties.sort_by{|t| t.kind}.each do |property|
    #puts "  . #{property.kind} => #{property.value.inspect}"
    printf "  %#{MAX_PROPERTY_LABEL_LENGTH}s => %s\n" % [property.key, property.value.inspect]
  end
  puts

  component.components.each do |child|
    display_component(child, component)
  end
end

file = ARGV[0] || '../../test-data/2445.ics'
root = Icalagator.new(:file => file)
puts "# Read #{file} and found #{root.components.size} components:"

root.components.sort_by{|t| t.kind}.each do |component|
  display_component(component)
end

puts "# DONE!"
