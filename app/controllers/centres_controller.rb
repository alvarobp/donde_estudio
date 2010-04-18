class CentresController < ApplicationController
  
  before_filter :set_filters, :only => [:index]
  
  def index
    if params[:q].blank?
      flash[:alert] = "Sabemos que la enseñanza en España está mal, pero seguro que hay algo mínimamente interesante. Por favor introduce algo en la caja de búsqueda."
      redirect_to home_url and return
    end
    
    @centres = Centre.search_with_filters(:text => params[:q], :filters => @filters,
      :page => params[:page], :per_page => 20)
      
    set_available_filters  
  end
  
  def show
    @centre = Centre.find_by_id(params[:id])
    render_404 and return unless @centre
  end
  
  def set_available_filters
    if params[:q] != session[:q]
      @facets = Centre.facets_with_filters(:text => params[:q], :filters => @filters,
          :page => params[:page], :per_page => 20)
        
      @available_filters = {}
    
      @facets.each do |filter, data|
        @available_filters[filter] = data.to_a.sort{|a,b| -a[1] <=> -b[1]}.slice(0,10).map{|d| d[0]}
      end
      
      session[:q] = params[:q]
      session[:available_filters] = @available_filters
    else
      @available_filters = session[:available_filters] || {}
    end
  end
  
end
