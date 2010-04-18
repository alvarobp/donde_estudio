ActionController::Routing::Routes.draw do |map|
  
  map.resources :centres, :only => [:index, :show]
  
  # DELETE ME
  map.connect '/home', :controller => 'site'
  #/
  
  map.root :controller => "site"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
