module OpenEducacion  
  class Teaching
    attr_accessor :level,
                  :area,
                  :teaching,
                  :mode,
                  :concerted
                  
    def initialize(options = {})
      @level, @area    = options[:level], options[:area]
      @teaching, @mode = options[:teaching], options[:mode]
      @concerted       = options[:concerted]
    end
    
    def to_hash
      {
        :level        => level,
        :area         => area,
        :teaching     => teaching,
        :mode         => mode,
        :concerted    => concerted
      }
    end
  end
end