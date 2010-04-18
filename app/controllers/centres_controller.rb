class CentresController < ApplicationController
  
  before_filter :set_filters, :only => [:index]
  
  def index
    @centres = Centre.search_with_filters(:text => params[:q], :filters => @filters,
      :page => params[:page], :per_page => 20)
  end
  
  def show
    @centre = Centre.find_by_id(params[:id])
    render_404 and return unless @centre
  end
  
end
