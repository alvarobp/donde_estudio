namespace :export do
  desc "exports the db into csv"
  task :csv  => :environment do |t|
    ::Centre.export_to_csv
  end
end