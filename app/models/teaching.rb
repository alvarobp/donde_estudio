class Teaching < ActiveRecord::Base
  
  belongs_to :centre
  
  def self.build_from_data(data={})
    return nil if data.blank?
    
    data = HashWithIndifferentAccess.new(data)
    
    data[:concerted] = (data[:concerted].sanitize == "si" ? true : false) unless data[:concerted].blank?
    
    Teaching.new(data)
  end
  
end
