require 'LibicalWrap'
require 'rubygems'
require 'facets/kernel/ergo'

# = Icalagator
#
# A high-level wrapper that makes it easy to use libical from Ruby.
#
# WARNING: This wrapper is not complete and its API is not stable. It currently
# only provides logic for parsing iCalendar data and extracting its contents.
#
# Naming conventions:
# * "raw_*" denotes an object referencing a libical data structure.
# * "*_i" denotes an integer, typically used to lookup enums in libical.
class Icalagator
  # TODO Provide way to populate data structures from Ruby.
  # TODO Provide way to translate Ruby objects to iCalendar text.
  
  # Return a new Component. Accepts the same arguments as Component.new.
  def self.new(opts={})
    return Component.new(opts)
  end

  module NormalizerMixin
    def self.included(mixee)
      mixee.extend(self)
    end

    # Return a normalized key, e.g., transforms "LAST_MODIFIED" into :last_modified.
    def normalize_key(key)
      return \
        case key
        when Symbol, Fixnum
          key
        when String
          key.downcase.gsub(/-/, '_').to_sym
        end
    end

    # Return a normalized kind, e.g., transforms :any to "ANY".
    def normalize_kind(kind)
      return kind.to_s.upcase.gsub(/_/, '-')
    end
  end

  # = Component
  #
  # A representation of an iCalendar component, such as an event.
  class Component
    include Icalagator::NormalizerMixin

    # Raw libical data structure.
    attr_accessor :raw

    # Raw iCalendar data string that was parsed.
    attr_accessor :data

    # Instantiate a new Component.
    #
    # Options:
    # * :data => Instantiate by parsing string with iCalendar data.
    # * :file => Instantiate by parsing iCalendar data stored in filename.
    # * :raw => Create new wrapper for this raw libical data structure.
    def initialize(opts={})
      if opts[:raw]
        self.raw = opts[:raw]
      elsif opts[:data]
        self.data = opts[:data]
      elsif opts[:file]
        self.data = File.read(opts[:file])
      end

      if self.data
        self.raw = LibicalWrap.icalcomponent_new_from_string(self.data)
      end
    end

    def inspect
      nodes = []
      nodes << "components.size=#{components.size}"
      self.properties.each do |property|
        nodes << "#{property.key}=#{property.value.inspect}"
      end
      return %{<#{self.class.name}:#{self.object_id} #{nodes.join(', ')}>}
    end

    # Return integer id for this kind of component.
    def kind_i
      return LibicalWrap.icalcomponent_isa(self.raw)
    end

    # Return text id of this kind of component.
    def kind
      return LibicalWrap.icalcomponent_kind_to_string(self.kind_i)
    end

    # Return array of raw libical component data structures embedded within this current Component.
    def raw_components(kind=:any)
      target_kind_i = LibicalWrap.icalcomponent_string_to_kind(normalize_kind(kind))
      results = []
      results << LibicalWrap.icalcomponent_get_first_component(raw, target_kind_i)
      while true
        item = LibicalWrap.icalcomponent_get_next_component(raw, target_kind_i)
        break unless item
        results << item
      end
      return results.uniq.compact
    end

    # Return array of Component instances embedded within this current Component.
    def components(kind=:any)
      return self.raw_components(kind).map{|t| Component.new(:raw => t)}
    end

    # Return array of event-like Component instances embedded within this current Component.
    def events
      return self.components(:vevent)
    end

    # Return array of raw libical property data structures for this Component.
    def raw_properties(kind=:any)
      target_kind_i = LibicalWrap.icalproperty_string_to_kind(normalize_kind(kind))
      results = []
      results << LibicalWrap.icalcomponent_get_first_property(raw, target_kind_i)
      while true
        item = LibicalWrap.icalcomponent_get_next_property(raw, target_kind_i)
        break unless item
        results << item
      end
      return results.uniq.compact
    end

    # Return array of Property instances. Optional +key+ limits results to a
    # specific kind of property, e.g., :x_lic_error.
    def properties(key=nil)
      key = normalize_key(key)
      return self.raw_properties.map{|t| Property.new(:raw => t)}.select{|t| key ? t.key == key : true}
    end

    # Return first matching value for this +key+.
    #
    # Example:
    #
    #   event.value_for(:summary) # => "Calagator code sprint"
    def value_for(key)
      key = normalize_key(key)
      return self.properties.find{|property| property.key == key}.ergo.value
    end

    # Return array of all matching property values for this +key+.
    #
    # Example:
    #
    #   event.values_for(:categories) # => ["CODE SPRINT", "CALAGATOR", "RUBY", "FUN"]
    def values_for(key)
      return self.properties(key).map{|t| t.value}
    end

    # Return array of property keys for this component.
    #
    # Example:
    #
    #   event.keys # => [:uid, :summary, ...]
    def keys
      return self.properties.map{|property| property.key.to_s}.sort.uniq.map{|key| key.to_sym}
    end

    # Returns property value or values associated with this +key+. If the key
    # is defined in Property::MULTIVALUE_PROPERTIES, then an array of values is
    # returned (e.g., :categories), else just the first match (e.g., :uid).
    def [](key)
      key = normalize_key(key)
      return Property.multivalue?(key) ? self.values_for(key) : self.value_for(key)
    end
  end

  # = Property
  #
  # A representation of an iCalendar property, such as a "DTSTART", "SUMMARY", etc.
  class Property
    include Icalagator::NormalizerMixin

    # Raw libical data structure.
    attr_accessor :raw

    # Properties that typically have multiple values. E.g., :categories is a
    # multivalue, but not :uid.
    MULTIVALUE_PROPERTIES = [
      LibicalWrap::ICAL_CATEGORIES_PROPERTY,
      LibicalWrap::ICAL_COMPONENTS_PROPERTY,
      LibicalWrap::ICAL_RESOURCES_PROPERTY,
      LibicalWrap::ICAL_XLICERROR_PROPERTY,
    ]

    # Does the property with this +key+ typically have multiple values? E.g.,
    # :categories is a multivalue, but not :uid.
    def self.multivalue?(key)
      key = normalize_key(key)
      key_i = LibicalWrap.icalproperty_string_to_kind(normalize_kind(key))
      MULTIVALUE_PROPERTIES.include?(key_i)
    end

    # Instantiate a new Property.
    #
    # Options:
    # * :raw => Create new wrapper for this raw libical data structure.
    def initialize(opts={})
      self.raw = opts[:raw]
    end

    def inspect
      return %{<#{self.class.name}:#{self.object_id} #{self.kind}="#{self.value}">}
    end

    # Return inteer id for this kind of property.
    def kind_i
      # Yes, component and not property
      return LibicalWrap.icalcomponent_isa(self.raw)
    end

    # Return text id of this kind of property.
    def kind
      # Yes, property and not component
      return LibicalWrap.icalproperty_kind_to_string(self.kind_i)
    end

    # Return normalized key for this kind of property. E.g. "LAST-MODIFIED" becomes :last_modified.
    def key
      return normalize_key(self.kind)
    end

    # Return value for this Property. This may be a String, Time, etc.
    def value
      case LibicalWrap.icalvalue_isa(self.raw_value)
      when LibicalWrap::ICAL_DATETIME_VALUE
        # TODO The icaldatetime has no TZ information and one must backtrack to its component and somehow match it with its TZID definition
        r = LibicalWrap.icalvalue_get_datetime(self.raw_value)
        Time.utc(r.year, r.month, r.day, r.hour, r.minute, r.second)
      else
        LibicalWrap.icalproperty_get_value_as_string_r(self.raw)
      end
    end

    # Return the raw value contained within this Property. The Property
    # is merely a container, the value is the payload.
    def raw_value
      return LibicalWrap.icalproperty_get_value(self.raw)
    end
  end
end
