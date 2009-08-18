class PostsController < ApplicationController
  
  #caches_page :index
    
  def index
    @posts = Post.by_published(:limit => 5)
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @post = Post.get(params[:id])
    
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
    
    respond_to do |format|
      format.html # by_year.html.erb
    end
  end
end
