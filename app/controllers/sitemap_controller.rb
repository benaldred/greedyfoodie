class SitemapController < ApplicationController
  def index
    @posts = Post.by_published
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml # index.xml.builder 
    end
  end

end
