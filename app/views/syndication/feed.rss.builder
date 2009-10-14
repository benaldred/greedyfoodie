xml.instruct! :xml, :version=>"1.0"
xml.rss :version => "2,0" do
  xml.channel do
    xml.title blog_title
    xml.link root_url
    xml.description blog_description if blog_description
    xml.langauge "en-gb"
    
    if @posts
      @posts.each do |post|
        xml.item do
          xml.title post.title
          xml.link post.url
          xml.description post.body
          xml.pubDate post.created_at
          xml.guid post.url
        end
      end
    end
    
  end
end 

