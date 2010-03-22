xml.instruct! :xml, :version=>"1.0" 
xml.urlset("xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd", :xmlns=>"http://www.sitemaps.org/schemas/sitemap/0.9") do
  # static pages
  xml.url do
    xml.loc root_url
    xml.changefreq "daily"
  end
  
  xml.url do
    xml.loc archives_url
    xml.changefreq "weekly"
  end
  
  # the posts
  if @posts
    @posts.each do |post|
      xml.url do
        xml.loc post.full_url
        xml.lastmod post.updated_at.rfc822
        xml.changefreq "monthly"
      end
    end
  end
  
end
  