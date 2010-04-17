class Teaching < ActiveRecord::Base
  
  belongs_to :centre
  
  def self.attributes_from_data(data={})
    return {} if data.blank?
    
    data = HashWithIndifferentAccess.new(data)
    
    data[:concerted] = (!data[:concerted].blank? && data[:concerted].sanitize == "si") ? true : false
    data
  end
  
end
