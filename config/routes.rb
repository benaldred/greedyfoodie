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
  
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.resource :user_session

  map.namespace :admin do |admin|
   admin.resources :posts, :member => { :preview => :get }
  end
  map.admin_root '/admin', :controller => 'admin/home'
  
  map.root :controller => "posts"

  # routing for blog posts
  map.archives '/archives', :controller => 'posts', :action => 'archives'
  map.by_year ':year', :controller => 'posts', :action => 'by_year', :year => /\d{4}/
  map.by_month ':year/:month', :controller => 'posts', :action => 'by_month', :year => /\d{4}/, :month => /\d{2}/
  map.post ':year/:month/:permalink', :controller => 'posts', :action => 'show'
  
  # syndication urls
  map.feed '/feed.:format',  :controller => 'syndication', :action => 'feed'
  map.sitemap '/sitemap.:format', :controller => 'syndication', :action => 'sitemap'
  
  # pages
  map.page ':page', :controller => 'pages', :action => 'show', :page => /about|contact/
  
  map.four_oh_four '/404', :controller => 'posts'
  
end
