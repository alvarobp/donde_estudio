module CentresHelper
  
  def centre_teachings_in_result(centre)
    centre.teachings.slice(0,5).map(&:teaching).join(', ')
  end
  
end
