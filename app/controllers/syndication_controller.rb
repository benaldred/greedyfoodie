class SyndicationController < ApplicationController
  
  before_filter :find_published_posts, :set_http_headers
  
  
  def sitemap
    respond_to do |format|
      format.html # sitemap.html.erb
      format.xml # sitemap.xml.builder 
    end
  end
  
  def feed
    respond_to do |format|
      format.rss # feed.rss.builder 
    end
  end
  
  private
  
  def find_published_posts
    @posts = Post.by_published
  end
  
  def set_http_headers
    cache_headers(Soapbox['blog_index_page_max_age'], @posts) 
  end

end
