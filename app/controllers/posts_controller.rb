class PostsController < ApplicationController
  
  before_filter :setup_sidebar
  
  
    
  def index
    @posts = Post.by_published(:limit => 5)
    cache_headers(Soapbox['blog_index_page_max_age'], @posts) 
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @post = Post.find_by_permalink(params[:permalink])
    
    cache_headers(Soapbox['blog_post_max_age'], @post, @post.updated_at) 
    respond_to do |format|
      if @post.published? && @post.verify_date?(:month => params[:month], :year => params[:year])
        
        format.html # show.html.erb
      else
        format.html { redirect_to("/404") }
      end
    end
  end
  
  def archives
    @post_sum_by_month = Post.sum_by_month
    
    respond_to do |format|
      format.html # archives.html.erb
    end
  end
  
  def by_year
    @posts = Post.find_by_year(params[:year])
    
    respond_to do |format|
      format.html # by_year.html.erb
    end
  end
  
  def by_month
    @posts = Post.find_by_year_and_month(params[:year], params[:month])
    @month_name = @posts.first.created_at.strftime("%B")
    
    respond_to do |format|
      format.html # by_year.html.erb
    end
  end
  
  protected
  
  def setup_sidebar
   if request.format.to_sym == :html  
      @recent_posts = Post.by_published(:limit => 5)
    end
  end
end
