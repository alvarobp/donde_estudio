require 'net/https'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'cgi'

module OpenEducacion
  class Scrap
    def initialize
      http_session          = Net::HTTP.new(URI_CENTERS.host, URI_CENTERS.port)
      http_session.use_ssl  = true
      @http                 = http_session.start
      @regions              = {}
      @provinces            = {}
      @center               = {}
      @logger = Logger.new("log/importar_centros.log")
    end
    
    def self.parse
      new.parse
    end

    def parse
      parse_regions
      parse_provinces
      parse_center
    end

    def regions
      @regions.values
    end

    def provinces
      @provinces.values
    end

    private

    def parse_regions
      # Obtenemos los codigos de las comunidades autonomas
      res = @http.get(URI_CENTERS.path)
      doc = Nokogiri::HTML(res.body)
      doc.xpath("//area").each do |area|
        if area['href'] =~ /selprov\('(\d+)','\d+'\)/
          @regions[area['alt'].to_sym] ||= Region.new(:name => area['alt'], :code => $1)
        end
      end
    end

    def parse_provinces
      # Para cada comunidad obtenemos los codigos de las provincias
      @regions.values.each do |region|
        res = @http.post(URI_REGIONS.path, "tipoOperacion=1&codaut=#{region.code}&codprov=00")
        doc = Nokogiri::HTML(res.body)
        doc.xpath("//area").each do |area|
          if area['href'] =~ /selprov\('\d+','(\d+)'\)/
            @provinces[area['alt'].to_sym] ||= Province.new(:name => area['alt'], :code => $1, :region => region )
          end
        end
      end
    end

    def parse_center
      provinces.each do |province|
        res = @http.post(URI_CENTER_SEARCH.path, query_string(default_search_params.merge('codaut' => province.region.code, 'codprov' => province.code)))
        doc = Nokogiri::HTML(res.body)
        trs_centros = doc.css("table.resultados tr")
        trs_centros.shift

        trs_centros.each do |tr_centro|
          begin
            link = tr_centro.search("td:first-child a").first
            code = $1 if link['href'] =~ /pas\('(\d+)'\)/
            centre_hash = OpenEducacion::Centre.new(:code => code, :province => province).to_hash            
            ::Centre.build_from_data(centre_hash).save!
            @logger.info "code:  #{code}"
          rescue
            @logger.info "Fallo importar centro\n#{centre_hash.inspect}\n\n#{$!}\n\n#{$!.backtrace.join('\n')}"
          end
        end
      end
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
    URI_REGIONS = URI.parse("https://www.educacion.es/centros/selectaut.do")    
    URI_CENTER = URI.parse("https://educacion.es/centros/saccen.do")
    URI_CENTER_SEARCH = URI.parse("https://educacion.es/centros/buscar.do")  
  end
end