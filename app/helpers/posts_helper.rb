module PostsHelper
  def link_to_post(post, title=nil)
    post_title = title ||post.title
    link_to h(post_title), post.url
  end
  
  def post_date(post)
    date = (post.new_record?) ? Time.now : post.created_at.to_date
    l(date, :format => :long)
  end
  
  def by_month_list(collection)
    list = []
    collection['rows'].each do |row|
      year, month = row["key"]
      date = Date.new(year, month)
      list << content_tag(:li,  link_to(date.strftime("%B %Y"), date.strftime("/%Y/%m")) + " " + content_tag(:span, row["value"]))
    end
    list.join("\n  ")
  end
  
  def content_for_post(post)
    # search through replace the <!-- more --> with a link and not display the rest
    content = post.body.gsub(/<!-- more -->.*$/m, link_to_post(post, 'Read more ...'))
    RedCloth.new(content).to_html
  end
  
  def recent_posts
    content_tag(:ul,
      @recent_posts.collect { |post| content_tag(:li, link_to_post(post)) }.join("\n"),
      :id => "recent_posts")
  end
end
