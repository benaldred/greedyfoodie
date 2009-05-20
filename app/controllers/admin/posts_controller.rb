class Admin::PostsController < ApplicationController
  def index
  end

  def new
  end
  
  def create
    # create the article
    
    respond_to do |format|
      format.html { redirect_to(edit_admin_post_url(1)) }
    end
    
  end

  def edit
  end

  def show
  end

end
