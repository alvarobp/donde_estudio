# == Schema Information
#
# Table name: centres
#
#  id                   :integer(4)      not null, primary key
#  code                 :string(255)
#  url                  :string(255)
#  denomination         :string(255)
#  generic_denomination :string(255)
#  country              :string(255)
#  region               :string(255)
#  province             :string(255)
#  town                 :string(255)
#  locality             :string(255)
#  county               :string(255)
#  address              :string(255)
#  postal_code          :string(255)
#  ownership            :string(255)
#  concerted            :boolean(1)      default(FALSE)
#  centre_type          :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Centre < ActiveRecord::Base
  
  has_many :teachings
  
  define_index do
    indexes :denomination
    indexes :generic_denomination
    indexes :country
    indexes :region
    indexes :province
    indexes :town
    indexes :locality
    indexes :county
    indexes :address
    indexes :ownership
    indexes :centre_type
    indexes teachings.level, :as => :levels
    indexes teachings.area, :as => :areas
    indexes teachings.teaching, :as => :teachings
    indexes teachings.mode, :as => :modes
    
    has :concerted
  end
  
  def to_array
    [
     code,
     denomination,
     region,
     province,
     province_subdivision,
     town,
     address,
     url,
     country,
     county,
     locality,
     postal_code,
     ownership,
     centre_type,
     generic_denomination,
     concerted
    ]
  end
  
  def full_address
    "#{address}, #{postal_code} #{province}"
  end
  
  
  def self.export_to_csv
    FasterCSV.open("doc/centros.csv", "w") do |csv|
      Teaching.all.each do |teaching|
        csv << teaching.centre.to_array + teaching.to_array
      end
    end
  end
  
  def self.build_from_data(data={})
    return nil if data.blank?
    
    data = HashWithIndifferentAccess.new(data)
    
    data[:concerted] = (!data[:concerted].blank? && data[:concerted].sanitize == "si" ? true : false)
    data[:ownership] = "Centro concertado" if data[:concerted]
    
    teachings_data = data.delete(:teachings) || []
    centre = Centre.new(data)
    
    if teachings_data
      centre.teachings.build(teachings_data.map{|td| Teaching.attributes_from_data(td)})
    end
    
    centre
  end
end
