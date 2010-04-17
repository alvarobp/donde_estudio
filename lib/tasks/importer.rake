namespace :scrap do
  task :education  => :environment do |t|
    OpenEducacion::Scrap.parse
  end
end