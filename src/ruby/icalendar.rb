require 'directory_info'

class ICalendar < DirectoryInfo
  attr_accessor :libical_self, :libical_kind

  def initialize(string)
    super(LibicalWrap.icalparser_parse_string(string))
    #string = string.gsub("\n ","")
    #!@libical_self = LibicalWrap.icalparser_parse_string(string)
    @libical_kind = LibicalWrap.icalcomponent_isa(@libical_self)
    unless @libical_kind == LibicalWrap::ICAL_VCALENDAR_COMPONENT
      @libical_self = nil
      t = @libical_kind
      @libical_kind = nil
      throw "The string does not parse to a VCALENDAR object"
    end
  end
  
  # This is just for convenince
  def name
    return "VCALENDAR"
  end
  
  def components
    count = LibicalWrap.icalcomponent_count_components(@libical_self, LibicalWrap::ICAL_ANY_COMPONENT)
    @components = [LibicalWrap.icalcomponent_get_first_component(@libical_self, LibicalWrap::ICAL_ANY_COMPONENT)]
    (count - 1).times do
      @components << LibicalWrap.icalcomponent_get_next_component(@libical_self, LibicalWrap::ICAL_ANY_COMPONENT)
    end
    return @components
  end
  
  ical_property :prodid, :text
  ical_property :version, :text
  ical_property :calscale, :text
  ical_property :method, :text
  #This perticular method doesn't use the ical_text_property default getter.  This is an example of how overloading ical_text_property works.
  def method
    return get_first_prop_value(LibicalWrap::ICAL_METHOD_PROPERTY)
  end

end
