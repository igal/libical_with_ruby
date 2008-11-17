require 'task_component'
class Event < TaskComponent
  
  def initialize(string)
    super(LibicalWrap.icalparser_parse_string(string))
  end
  
  # This is just for convenince
  def name
    return "VEVENT"
  end
  
  ical_property :transp, :text
  def transp
    prop = get_first_prop_value(LibicalWrap::ICAL_TRANSP_PROPERTY)
    return prop || "OPAQUE"
  end
  
  #TODO - need to add dtend
  
end