class Centre < ActiveRecord::Base
  
  has_many :teachings
  
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
