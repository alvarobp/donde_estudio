module FilterTags
  module StringExtension
    def sanitize
      return if self.empty?
      self.parameterize.to_s
    end
  end
end

String.send(:include, FilterTags::StringExtension) unless String.instance_methods.include?("sanitize")