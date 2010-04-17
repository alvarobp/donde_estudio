# == Schema Information
#
# Table name: teachings
#
#  id         :integer(4)      not null, primary key
#  centre_id  :integer(4)
#  level      :string(255)
#  area       :string(255)
#  teaching   :string(255)
#  mode       :string(255)
#  concerted  :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class Teaching < ActiveRecord::Base
  
  belongs_to :centre
  
  def self.attributes_from_data(data={})
    return {} if data.blank?
    
    data = HashWithIndifferentAccess.new(data)
    
    data[:concerted] = (!data[:concerted].blank? && data[:concerted].sanitize == "si") ? true : false
    data
  end
  
end
