require 'progressbar'
require 'typhoeus'
require 'nokogiri'

namespace :scrap do
  desc 'Fetches all educacion.es/centros info'
  task :education  => :environment do |t|
    centres = OpenEducacion::Centres.all
    pbar = ProgressBar.new("Centres parsed", centres.size*2)
    hydra = Typhoeus::Hydra.new(:max_concurrency => 160)
    centre_logger = Logger.new("log/importar_centros.log")
    @@centres_hash = []
    
    centres.each do |centre_code|
      centre = OpenEducacion::Centre.new(centre_code)
      request = Typhoeus::Request.new(OpenEducacion::Centre::URI_CENTER_SEARCH.to_s,
                                      :method        => :post,
                                      :params        => centre.request_params,
                                      :disable_ssl_peer_verification => true)
      request.on_complete do |response|
        centre.instance_eval{ @doc = Nokogiri::HTML(response.body) }
        if centre.denomination.nil?
          centre_logger.info "#{centre.code}, "
        else
          @@centres_hash << centre        
        end
        pbar.inc
      end
      
      hydra.queue request
    end
    hydra.run

    @@centres_hash.each do |cen|
      Centre.build_from_data(cen.to_hash).save!
      pbar.inc
    end
    pbar.finish
  end
end