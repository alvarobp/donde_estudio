require 'net/https'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'cgi'

module OpenEducacion
  class Centre
    attr_accessor :code, :province, :doc

    def initialize(options = {})
      @code     = options[:code]
      @province = options[:province]
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
          teaching << Teaching.new( :level => (rows.shift.content.strip rescue nil), 
                                     :area => (rows.shift.content.strip rescue nil), 
                                     :teaching => (rows.shift.content.strip rescue nil), 
                                     :mode => (rows.shift.content.strip rescue nil), 
                                     :concerted => (rows.shift.content.strip rescue nil) )
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
    
    def to_s
      "#{denomination} - #{locality} -  #{teachings}"
    end
    
    private
    
    def document
      return @doc if @doc      
      http_session          = Net::HTTP.new(URI_CENTERS.host, URI_CENTERS.port)
      http_session.use_ssl  = true
      http                 = http_session.start
      res = http.post(URI_CENTER_SEARCH.path, query_string(default_search_params.merge('codaut' => @province.region.code, 'codprov' => @province.code, 'codcen' => @code)))
      @doc = Nokogiri::HTML(res.body)
    end
   
    def default_search_params
      { "simostrar"       => "si",
        "codaut"          => "16",
        "codprov"         => "46",
        "codcen"          => "",
        "codcen2"         => "",
        "denomiespe"      => "",
        "ssel_natur"      => "0",
        "sconcerta"       => "0",
        "tipocentro"      => "0",
        "combosub"        => "",
        "combomuni"       => "",
        "comboloc"        => "0",
        "comboniv"        => "-1",
        "combogra"        => "",
        "comboens"        => "-1",
        "combopais"       => "",
        "comboislas"      => "",
        "comboprovin"     => "",
        "nombreaut"       => "COMUNIDAD VALENCIANA", # Se puede omitir
        "nombrepro"       => "VALENCIA", # Se puede omitir
        "textotipocentro" => "todos",
        "textosub"        => "",
        "textomunicipio"  => "",
        "textolocalidad"  => "todos",
        "textonivel"      => "todos",
        "textogrado"      => "",
        "textoensenanza"  => "todos",
        "textopais"       => "",
        "textonaturaleza" => "todos",
        "textoconcertado" => "todos" }
    end
    
    def query_string(parameters={})
      parameters.map{ |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
    end
    URI_CENTERS = URI.parse("https://www.educacion.es/centros/")
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
    
    def to_hash
      {
        :level        => level,
        :area         => area,
        :teaching     => teaching,
        :mode         => mode,
        :concerted    => concerted
      }
    end
    def to_s
      "teachings => #{@level} - #{@area} -  #{@teaching} - #{@mode} - #{@concerted}"
    end
    
  end
end