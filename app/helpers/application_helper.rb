# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def titleize_string(string)
    return '' if string.blank?
    string = string.titleize
    
    string.gsub!(/[^\s]+Á/) {|s| s.gsub('Á','á')}
    string.gsub!(/[^\s]+À/) {|s| s.gsub('À','à')}
    string.gsub!(/[^\s]+É/) {|s| s.gsub('É','é')}
    string.gsub!(/[^\s]+È/) {|s| s.gsub('È','è')}
    string.gsub!(/[^\s]+Í/) {|s| s.gsub('Í','í')}
    string.gsub!(/[^\s]+Ì/) {|s| s.gsub('Ì','ì')}
    string.gsub!(/[^\s]+Ó/) {|s| s.gsub('Ó','ó')}
    string.gsub!(/[^\s]+Ò/) {|s| s.gsub('Ò','ò')}
    string.gsub!(/[^\s]+Ú/) {|s| s.gsub('Ú','ú')}
    string.gsub!(/[^\s]+Ù/) {|s| s.gsub('Ù','ù')}
    
    string.gsub!(/[^\s]+Ñ/) {|s| s.gsub('Ñ','ñ')}
    string.gsub!(/[^\s]+Ç/) {|s| s.gsub('Ç','ç')}
    
    string
  end
  
end
