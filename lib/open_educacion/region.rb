module OpenEducacion
  class Region
    
    attr_accessor :name, :code
    
    def initialize(options = {})
      @name = options[:name]
      @code = options[:code].to_i
    end    
    
  end
end