class Admin::PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
  end
  
  def create
    # create the article
    @post = Post.new(params[:post])
    
    respond_to do |format|
      if params[:preview]
        format.html {
          Rails.cache.write("post-preview", @post)
          redirect_to(preview_admin_post_url(@post.generate_unique_permalink_from_title))
        }
      else
        @post.status = 'published' if params[:publish]
        if @post.save
          format.html { redirect_to(edit_admin_post_url(@post.id)) }
        else
          format.html { render :action => "new" }
        end
      end
    end
    
  end

  def edit
    @post = Post.get(params[:id])
  end
  
  def update
    @post = Post.get(params[:id])
    
    respond_to do |format|
      if params[:preview]
        format.html {
          @new_post = Post.new(params[:post])
          Rails.cache.write("post-preview", @new_post)
          redirect_to(preview_admin_post_url(@new_post.generate_unique_permalink_from_title))
        }
      else
        if @post.update_attributes(params[:post])
          format.html { redirect_to(edit_admin_post_url(@post.id)) }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end

  def preview
    @post = Rails.cache.read("post-preview")
    Rails.cache.delete("post-preview")
    
    respond_to do |format|
      format.html { render :template => 'posts/show'}
    end
  end
  
  def post_preview
    @post = Post.new(:title => params[:post_title], :body => params[:post_body])
    
    respond_to do |format|
      format.html { render :template => 'posts/show'}
    end
  end
  
  def destroy
    @post = Post.get(params[:id])
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to(admin_posts_path) }
    end
  end

end
