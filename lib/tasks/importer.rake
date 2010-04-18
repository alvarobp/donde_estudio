namespace :scrap do
  desc 'Fetches all educacion.es/centros info'
  task :education  => :environment do |t|
    OpenEducacion::Scrap.parse
  end
end