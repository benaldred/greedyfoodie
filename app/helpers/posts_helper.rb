module PostsHelper
  def link_to_post(post)
    year, month = post.year_and_month
    link_to h(post.title), "#{year}/#{month}/#{post.permalink}"
  end
  
  def display_post_date(post)
    date = (post.new_record?) ? Time.now : post.created_at.to_date
    l(date, :format => :long)
  end
end
