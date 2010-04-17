require 'net/https'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'cgi'

module OpenEducacion
  class Centre
    attr_accessor :code

    def initialize(code)
      @code = code
    end
    
    def denomination
      document.at("tr:nth-child(2) tr:nth-child(2) .datostd").content.strip
    end

    def region
      document.at(".tablacentro table tr:nth-child(1) :nth-child(2)").content.strip
    end
    
    def province
      document.at(".tablacentro table tr:nth-child(2) :nth-child(2)").content.strip
    end
    
    def province_subdivision
      document.at(".tablacentro table tr:nth-child(3) :nth-child(4)").content.strip
    end
    
    def town
      document.at(".tablacentro tr:nth-child(4) .datostd").content.strip
    end
    
    def address
      document.at(".tablacentro table tr:nth-child(5) :nth-child(2)").content.strip
    end
    
    def url
      document.at(".tablacentro table tr:nth-child(6) :nth-child(2)").content.strip
    end
    
    def country
      document.at(".tablacentro table tr:nth-child(2) :nth-child(4)").content.strip
    end
    
    def county
      document.at(".tablacentro table tr:nth-child(3) :nth-child(2)").content.strip
    end
    
    def locality
      document.at(".tablacentro table tr:nth-child(4) :nth-child(4)").content.strip
    end
    
    def postal_code
      document.at(".tablacentro table tr:nth-child(5) :nth-child(4)").content.strip
    end
    
    def ownership
      document.at("tr:nth-child(6) tr:nth-child(1) :nth-child(2)").content.strip
    end
    
    def centre_type
      document.at("tr:nth-child(6) tr:nth-child(2) .datostd").content.strip
    end
    
    def generic_denomination
      document.at("tr:nth-child(6) tr:nth-child(3) .datostd").content.strip
    end
    
    def concerted
      document.at("tr:nth-child(6) .tablacentro :nth-child(4)").content.strip
    end
    
    def teachings
      returning([]) do |teaching|
        rows = document.search("tr:nth-child(8) .datostd")
        while rows.size != 0 do
          teaching << Teaching.new( :level => rows.shift.content.strip, 
                                     :area => rows.shift.content.strip, 
                                     :teaching => rows.shift.content.strip, 
                                     :mode => rows.shift.content.strip, 
                                     :concerted => rows.shift.content.strip )
        end
      end
    end
    
    private
    
    def document
      return @doc if @doc
      http_session          = Net::HTTP.new(URI_CENTERS.host, URI_CENTERS.port)
      http_session.use_ssl  = true
      http                 = http_session.start
      res = @http.post(URI_CENTER_SEARCH.path, query_string(default_search_params.merge('codaut' => province.region.code, 'codprov' => province.code, 'codcen' => code)))
      @doc = Nokogiri::HTML(res.body)
    end
    
    URI_CENTER_SEARCH = URI.parse("https://educacion.es/centros/buscar.do")    
  end
  
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
  end
end