class Centre < ActiveRecord::Base
  
  def self.build_from_data(data={})
    return nil if data.blank?
    
    data = HashWithIndifferentAccess.new(data)
    
    unless data[:concerted].blank?
      data[:concerted] = (data[:concerted].sanitize == "si" ? true : false)
      data[:ownership] = "Centro concertado" if data[:concerted]
    end
    
    Centre.new(data)
  end
  
end
