# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def render_404
    render :layout => false, :file => 'public/404.html', :status => '404'
  end
  
  def filters_params(options = {})
    @filters ||= {}
    
    filters = @filters.inject({}) {|o, (k,v)| o[k] = v.dup; o}
    
    if options[:add]
      options[:add].each do |filter, value|
        filters[filter] ||= []
        if value.is_a?(String)
          filters[filter] << value
        elsif value.is_a?(Array)
          filters[filter] += value
        end
        filters[filter].uniq!
      end
    end
    
    if options[:remove]
      options[:remove].each do |filter, value|
        next if filters[filter].nil?
        
        if value.is_a?(String)
          filters[filter].delete(value)
        elsif value.is_a?(Array)
          filters[filter] -= value
        end
        filters[filter].uniq!
      end
    end
    
    filters_for_params = filters.inject({}) do |o, (filter, value)|
      o[filter] = value.is_a?(Array) ? value.join(' ') : value unless value.blank?
      o
    end
  end
  helper_method :filters_params
  
  private
  
  def set_filters
    @filters = {}
    
    (Centre.filters + Teaching.filters).each do |filter|
      if params[filter]
        @filters[filter] = params[filter].split(' ')
      end
    end
    
    @filters[:q] = params[:q] unless params[:q].blank?
  end
  
end
