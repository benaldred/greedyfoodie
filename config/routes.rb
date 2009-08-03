ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  map.namespace :admin do |admin|
   admin.resources :posts, :member => { :preview => :get }, :collection => {:post_preview => :post}
  end
  map.connect '/admin', :controller => 'admin/posts'
  map.root :controller => "posts"

  # routing for blog posts
  map.post ':year/:month/:permalink', :controller => 'posts', :action => 'show', :id => :permalink
  #map.connect ':year/:month', :controller => 'posts', :action => 'by_month', :year => /\d{4}/, :month => /\d{2}/
  #map.connect ':year', :controller => 'posts', :action => 'by_year', :year => /\d{4}/
  
end
