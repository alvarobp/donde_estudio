require 'net/https'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'cgi'

module OpenEducacion
  class Centre
    attr_accessor :code, :doc

    def initialize(code)
      @code = code
    end
    
    def denomination
      document.at("tr:nth-child(2) tr:nth-child(2) .datostd").content.strip rescue nil
    end

    def region
      document.at(".tablacentro table tr:nth-child(1) :nth-child(2)").content.strip rescue nil
    end
    
    def province
      document.at(".tablacentro table tr:nth-child(2) :nth-child(2)").content.strip rescue nil
    end
    
    def province_subdivision
      document.at(".tablacentro table tr:nth-child(3) :nth-child(4)").content.strip rescue nil
    end
    
    def town
      document.at(".tablacentro tr:nth-child(4) .datostd").content.strip rescue nil
    end
    
    def address
      document.at(".tablacentro table tr:nth-child(5) :nth-child(2)").content.strip rescue nil
    end
    
    def url
      document.at(".tablacentro table tr:nth-child(6) :nth-child(2)").content.strip rescue nil
    end
    
    def country
      document.at(".tablacentro table tr:nth-child(2) :nth-child(4)").content.strip rescue nil
    end
    
    def county
      document.at(".tablacentro table tr:nth-child(3) :nth-child(2)").content.strip rescue nil
    end
    
    def locality
      document.at(".tablacentro table tr:nth-child(4) :nth-child(4)").content.strip rescue nil
    end
    
    def postal_code
      document.at(".tablacentro table tr:nth-child(5) :nth-child(4)").content.strip rescue nil
    end
    
    def ownership
      document.at("tr:nth-child(6) tr:nth-child(1) :nth-child(2)").content.strip rescue nil
    end
    
    def centre_type
      document.at("tr:nth-child(6) tr:nth-child(2) .datostd").content.strip rescue nil
    end
    
    def generic_denomination
      document.at("tr:nth-child(6) tr:nth-child(3) .datostd").content.strip rescue nil
    end
    
    def concerted
      document.at("tr:nth-child(6) .tablacentro :nth-child(4)").content.strip rescue nil
    end
    
    def teachings
      returning([]) do |teaching|
        rows = document.search("tr:nth-child(8) .datostd")
        while rows.size != 0 do
          teaching << OpenEducacion::Teaching.new(:level => clean_blank(rows.shift), 
                                   :area => clean_blank(rows.shift), 
                                   :teaching => clean_blank(rows.shift), 
                                   :mode => clean_blank(rows.shift), 
                                   :concerted => clean_blank(rows.shift))
        end
      end
    end
    
    def to_hash
      {
       :code                 => @code,
       :denomination         => denomination,
       :region               => region,
       :province             => province,
       :province_subdivision => province_subdivision,
       :town                 => town,
       :address              => address,
       :url                  => url,
       :country              => country,
       :county               => county,
       :locality             => locality,
       :postal_code          => postal_code,
       :ownership            => ownership,
       :centre_type          => centre_type,
       :generic_denomination => generic_denomination,
       :concerted            => concerted,
       :teachings            => teachings.map(&:to_hash)
      }
    end
    
    def request_params
      default_search_params.merge(:codcen => @code)
    end
    
    private
    
    def clean_blank(value)
      value.content.strip.gsub("\302\240", "") rescue nil
    end
    
    def document
      return @doc if defined?(@doc)
      http_session          = Net::HTTP.new(URI_CENTER_SEARCH.host, URI_CENTER_SEARCH.port)
      http_session.use_ssl  = true
      http                  = http_session.start
      res = http.post(URI_CENTER_SEARCH.path, query_string(request_params))
      @doc = Nokogiri::HTML(res.body)
    end
   
    def default_search_params 
      {
        :codaut	=>"00",
        :codcen	=>"52004792",
        :codprov	=>"00",
        :codprovincia	=>"19",
        :comboens	=>"-1",
        :comboniv	=>"-1",
        :limite	=>"100",
        :nombreaut	=>"",
        :nombrepro	=>"",	
        :sconcerta	=>"0",
        :simostrar	=>"no",
        :texto	=>"",	
        :textocomarca	=>"",	
        :textoensenanza	=>"todos",
        :textolocalidad	=>"",
        :textomunicipio	=>"",
        :textonaturaleza	=>"todos",
        :textonivel	=>"todos",
        :textopais	=>"",
        :textosub	=>"",
        :textotipocentro	=>"todos",
        :tipocaso=>"0",
      }      
    end
    
    def query_string(parameters={})
      parameters.map{ |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
    end
    
    URI_CENTER_SEARCH = URI.parse("https://educacion.es/centros/buscar.do")    
  end
end