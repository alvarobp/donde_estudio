require 'net/https'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'cgi'

module OpenEducacion
  class Centres    
    
    def self.all
      returning([]) do |codes|
        centres = document.css("table.resultados tr")
        centres.shift
        centres.each do |centre|
         link = centre.search("td:first-child a").first
         codes << $1 if link['href'] =~ /pas\('(\d+)'\)/
        end
      end
    end
    
    private
    
    def self.document
      return @doc if defined?(@doc)
      
      # very heavy html lets save some time if we managed to have it already like a fixture
      return @doc = Nokogiri::HTML(File.open(HTML_FIXTURE)) if File.exists?(HTML_FIXTURE)
      
      http_session          = Net::HTTP.new(URI_CENTER_SEARCH.host, URI_CENTER_SEARCH.port)
      http_session.use_ssl  = true
      http                  = http_session.start
      res = http.post(URI_CENTER_SEARCH.path, query_string(default_search_params))
      @doc = Nokogiri::HTML(res.body)
    end
    
    def self.default_search_params
      {
        :codaut	=> "00",
        :codcen	=> "",	
        :codcen2	=> "",	
        :codprov	=> "00",
        :comboens	=> "-1",
        :combogra	=> "",	
        :comboislas	=> "",	
        :comboloc	=> "",	
        :combomuni	=> "",	
        :comboniv	=> "-1",
        :combopais	=> "",	
        :comboprovin	=> "",	
        :combosub	=> "",	
        :denomiespe	=> "",	
        :nombreaut	=> "",	
        :nombrepro	=> "",	
        :sconcerta	=> "0",
        :simostrar	=> "si",
        :ssel_natur	=> "0",
        :textoensenanza	=> "todos",
        :textogrado	=> "",	
        :textolocalidad	=> "",	
        :textomunicipio	=> "",	
        :textonaturaleza	=> "todos",
        :textonivel	=> "todos",
        :textopais	=> "",	
        :textosub	=> "",	
        :textotipocentro	=> "todos",
        :tipocentro	=> "0"
      }
    end
    
    def self.query_string(parameters={})
      parameters.map{ |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
    end
    
    HTML_FIXTURE      = "test/fixtures/todos_centros.html"
    URI_CENTER_SEARCH = URI.parse("https://educacion.es/centros/buscar.do")  
  end
end