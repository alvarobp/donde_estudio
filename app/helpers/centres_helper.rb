module CentresHelper
  
  def centre_teachings_in_result(centre)
    centre.teachings.slice(0,5).map{|t| titleize_string(t.teaching)}.join(', ')
  end
  
  def filter_link(text, filter, value)
    present = !!@filters[filter].try(:include?, value)
    
    li_class = present ? ' class="filter-selected"' : ''
    "<li#{li_class}><a href=\"#{ centres_url(filters_params( {:"#{present ? "remove" : "add"}" => {filter => value} })) }\">#{text}</a></li>"
  end
  
  # def filter_link(text, filter, value, options={})
  #   li_class = @filters[filter].include?(value) ? ' class="filter-selected"' : ''
  #   "<li#{li_class}><a href=\"#{centres_url(filters_params(options.merge({:add => {filter => value}})))}\">#{text}</a></li>"
  # end
end
