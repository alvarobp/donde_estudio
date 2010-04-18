require 'progressbar'
require 'typhoeus'
require 'nokogiri'
require 'ruby-debug'

namespace :scrap do
  desc 'Fetches all educacion.es/centros info'
  task :education  => :environment do |t|
    centres = OpenEducacion::Centres.all
    pbar = ProgressBar.new("Centres parsed", centres.size)
    hydra = Typhoeus::Hydra.new(:max_concurrency => 500)
    
    centres.each do |centre_code|
      centre = OpenEducacion::Centre.new(centre_code)
      request = Typhoeus::Request.new(OpenEducacion::Centre::URI_CENTER_SEARCH.to_s,
                                      :method        => :post,
                                      :params        => centre.request_params,
                                      :disable_ssl_peer_verification => true)
      request.on_complete do |response|
        centre.instance_eval{ @doc = Nokogiri::HTML(response.body) }
        centre.to_hash
        #::Centre.build_from_data().save!
        pbar.inc
      end
      hydra.queue request
      hydra.run
    end
    pbar.finish
  end
end