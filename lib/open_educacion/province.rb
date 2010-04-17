module OpenEducacion
  class Province
    
    attr_accessor :name, :code, :region

    def initialize(options = {})
      @name   = options[:name]
      @code   = options[:code].to_i
      @region = options[:region]
    end
  end
end