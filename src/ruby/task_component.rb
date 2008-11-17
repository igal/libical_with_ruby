require 'calendar_component'

class TaskComponent < CalendarComponent
  
  ical_property :location, :text
  ical_property :priority, :int
  
end