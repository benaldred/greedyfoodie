class Admin::PostsController < Admin::AdminController
  
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
          session["post_preview"] =  @post
          redirect_to(preview_admin_post_url(@post.generate_unique_permalink_from_title))
        }
      else
        @post.status = 'published' if params[:publish]
        if @post.save
          format.html { redirect_to(edit_admin_post_url(@post.permalink)) }
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
          session["post_preview"] = @new_post
          redirect_to(preview_admin_post_url(@new_post.generate_unique_permalink_from_title))
        }
      else
        @post.status = 'published' if params[:publish]
        if @post.update_attributes(params[:post])
          format.html { redirect_to(edit_admin_post_url(@post.permalink)) }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end

  def preview
    
    if session["post_preview"]
      @post = session["post_preview"]
      session["post_preview"] = nil
    end
    
    #use id if on query string
    @post = Post.get(params[:id]) if params[:id]
    
    respond_to do |format|
      format.html { render :template => 'posts/show', :layout => 'application'}
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
