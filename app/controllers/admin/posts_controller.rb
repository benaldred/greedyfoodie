class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end
  
  def create
    # create the article
    @post = Post.new(params[:post])
    @post.status = 'published' if params[:commit] == "Publish"
    
    respond_to do |format|
      if @post.save
        format.html { redirect_to(edit_admin_post_url(@post.id)) }
      else
        format.html { render :action => "new" }
      end
    end
    
  end

  def edit
    @post = Post.get(params[:id])
  end
  
  def update
    @post = Post.get(params[:id])
    
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(edit_admin_post_url(@post.id)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def show
  end
  
  def destroy
    @post = Post.get(params[:id])
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to(admin_posts_url) }
    end
  end

end
