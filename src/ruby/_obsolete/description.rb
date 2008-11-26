require 'ical_property'
module Description
  include IcalProperty
  include IcalProperty::PropertyHelper
  
  ical_property :duration, :text
  
end