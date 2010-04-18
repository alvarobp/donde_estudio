class CentresController < ApplicationController
  
  def index
    @centres = Centre.search(params[:q], :page => params[:page], :per_page => 20)
  end
  
  def show
    @centre = Centre.find_by_id(params[:id])
    render_404 and return unless @centre
  end
  
end
