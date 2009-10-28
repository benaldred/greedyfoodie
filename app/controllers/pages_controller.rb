class PagesController < ApplicationController
  
  before_filter :setup_sidebar
  
  
    
  def show    
    respond_to do |format|
      format.html { render :action => params[:page] }
    end
  end

  
  protected
  
  def setup_sidebar
   if request.format.to_sym == :html  
      @recent_posts = Post.by_published(:limit => 5)
    end
  end
end
