ActionController::Routing::Routes.draw do |map|
  
  map.home "", :controller => "site"
  
  map.resources :centres, :only => [:index, :show]
  
  map.root :controller => "site"
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
