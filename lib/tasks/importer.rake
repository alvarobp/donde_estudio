require 'progressbar'

namespace :scrap do
  desc 'Fetches all educacion.es/centros info'
  task :education  => :environment do |t|
    centres = OpenEducacion::Centres.all
    pbar = ProgressBar.new("Centres parsed", centres.size)
    
    centres.each do |centre_code|
      centre = OpenEducacion::Centre.new(centre_code).to_hash
      ::Centre.build_from_data(centre).save!
      pbar.inc
    end
    pbar.finish
  end
end