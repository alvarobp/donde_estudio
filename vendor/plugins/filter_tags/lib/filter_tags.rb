module FilterTags
  
  def self.included(base)
    base.extend Charger
  end
  
  module InstanceMethods
    def filters
      instance_filters = {}
      
      self.class.filters.each do |filter|
        if !self.send(filter).blank?
          instance_filters[filter] = self.class.filter_tag_value(self.send(filter))
        end
      end
      
      instance_filters
    end
    
    private
    
    def serialize_filter_tags
      self.filter_tags = filters.inject([]) {|array, (filter,value)| array << Centre.filter_tag_for(filter, value); array }
    end
  end
  
  module ClassMethods
    def filters
      @filters
    end
    
    def filter_tag_for(filter, value)
      if @filters.map(&:to_s).include?(filter.to_s)
        "#{filter}__#{filter_tag_value(value)}"
      end
    end
    
    def filter_tag_to_value(filter_tag)
      if @filters.any?{ |filter| filter_tag =~ /^#{filter}__([^\s]+)/ }
        $1
      end
    end
    
    def filter_tag_value(string)
      string.sanitize.gsub('-', '_')
    end
  end
  
  module Charger
    def has_filter_tags(*filters)
      @filters = *filters
      
      include InstanceMethods
      extend ClassMethods
      
      serialize :filter_tags, Array
      
      before_save :serialize_filter_tags
    end
  end
  
end