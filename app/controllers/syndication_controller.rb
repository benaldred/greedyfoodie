class SyndicationController < ApplicationController
  def sitemap
    @posts = Post.by_published
    
    respond_to do |format|
      format.html # sitemap.html.erb
      format.xml # sitemap.xml.builder 
    end
  end
  
  def feed
    @posts = Post.by_published
    
    respond_to do |format|
      format.rss # feed.rss.builder 
    end
  end
  

end
