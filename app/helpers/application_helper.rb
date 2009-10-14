# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller.controller_name}_#{controller.action_name}"
  end
  
  def document_title(sep="-")
    title = blog_title
    @page_title = page_title
    # show blog posts use blog title
    title = "#{@page_title} #{sep} #{blog_title}" if @page_title 
    title
  end
  
  def page_title
    @page[:title] if @page
  end
   
  #convenience methods
  def blog_title
    Soapbox['blog_title']
  end
  
  def blog_strapline
    Soapbox['strapline']
  end
  
  def blog_description
    Soapbox['blog_description']
  end
  
  def post_preview?
    @post_preview
  end
  
  private
  
  def viewing_post?
    controller.controller_name == 'posts' && controller.action_name == 'show'
  end
end
 