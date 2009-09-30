class Admin::PostsController < Admin::AdminController
  
  def index
    @posts = Post.by_admin_posts
  end

  def new
  end
  
  def create
    # create the post
    @post = Post.new_from_params(params)
    
    respond_to do |format|
        if @post.save
          format.html {
            params[:preview] ? redirect_to(preview_admin_post_url(@post.permalink)) : redirect_to(edit_admin_post_url(@post.permalink))
           }
        else
          format.html { render :action => "new" }
        end
    end
    
  end

  def edit
    @post = Post.find_by_permalink(params[:id]) 
  end
  
  def update
    @post = Post.find_by_permalink(params[:id]) 
    
    #should we see if they diff
    @post.preview = params[:post][:body] if params[:preview]
    
    @post.status = 'published' if params[:publish]
    
    respond_to do |format|
      
      @post.status = 'published' if params[:publish]
      if @post.update_attributes(params[:post])
        format.html { 
          params[:preview] ? redirect_to(preview_admin_post_url(@post.permalink)) : redirect_to(edit_admin_post_url(@post.permalink)) 
        }
      else
        format.html { render :action => "edit" }
      end   
    end
  end

  def preview
    #mark the post as a preview
    @post_preview = true
    
    #use id if on query string
    
    @post = Post.find_by_permalink(params[:id])
    @post.body = @post.preview unless @post.preview.nil?
    
    
    respond_to do |format|
      format.html { render :template => 'posts/show', :layout => 'application'}
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
