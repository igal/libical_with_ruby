require 'LibicalWrap'
require 'ical_property'

class DirectoryInfo
  include IcalProperty
  include IcalProperty::PropertyHelper
  
  attr_accessor :libical_self
  
  def initialize(libical_self = nil)
    @charset = nil
    @content_id = nil
    @conctent_type = nil
    @name = ''
    @profile = nil
    @source = nil
    @x_prop = nil
    @libical_self = libical_self
  end
  
  def to_ical
    s = LibicalWrap.icalcomponent_as_ical_string(@libical_self)
    return s
  end

  # nodoc
  # This was stolen right out of the Rails 1.0 code, thanks guys =-)
  def extract_options_from_args!(args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    validate_find_options(options)
    options
  end

end
