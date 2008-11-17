module IcalProperty  
  def self.append_features(base)
    base.extend ClassMethods
  end
  module PropertyHelper
    def get_first_prop(prop_kind)
      count = LibicalWrap.icalcomponent_count_properties(@libical_self, prop_kind)
      return nil if count < 1
      return LibicalWrap.icalcomponent_get_first_property(@libical_self, prop_kind)
    end

    def get_first_prop_value(prop_kind)
      prop = get_first_prop(prop_kind)
      return nil unless prop
      return LibicalWrap.icalproperty_get_value_as_string(prop)
    end

    def get_or_create_first_prop(prop_kind)
      prop = get_first_prop(prop_kind)
      if prop.nil?
        prop = LibicalWrap.icalproperty_new(prop_kind)
        LibicalWrap.icalcomponent_add_property(@libical_self, prop)
      end
      return prop
    end

    def set_first_prop_value(prop_kind, value)
      prop = get_or_create_first_prop(prop_kind)
      LibicalWrap.icalproperty_set_value_from_string(prop, value, "NO")
    end
  end
  
  module ClassMethods
    def ical_property(property, type)
      string = "#{property}".strip.upcase
      getter = "#{string.downcase}"
      setter = "#{string.downcase}="
      string[/_/] = '-' if string =~ /_/
    
      unless instance_methods.include? getter
        code = <<-code
          def #{getter}
            return get_first_prop_value(LibicalWrap::ICAL_#{string}_PROPERTY)
          end
        code
        if type == :int || type == 'int'
          code = code.gsub(/PROPERTY\)/, "PROPERTY).to_i")
        end
        class_eval code, "directory_info.rb", 46
      end
      unless instance_methods.include? setter
        code = <<-code
          def #{setter} value
            return set_first_prop_value(LibicalWrap::ICAL_#{string}_PROPERTY, value)
          end
        code
        if type == :int || type == 'int'
          code = code.gsub(/value\)/, "value.to_s)")
        end
        class_eval code, "directory_info.rb", 57
      end
    end
  end
end