class PostSweeper < ActionController::Caching::Sweeper
  observe Post
  
  def after_save(record)
    expire_page :controller => 'posts', :action => 'index'
  end
  
end