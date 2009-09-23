require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationHelper do
  include ApplicationHelper
  
  def controller
    @controller
  end

  before(:each) do
    
  end
  
  
  describe "body_class" do
    before do
      @controller = mock('controller', :controller_name => 'foo', :action_name => 'index')
    end
     
    it "should return classes based on the current controller and action" do
      body_class.should == "foo foo_index" 
    end
  end 
  
  describe "document_title" do
         
    it "should display the blog name on the root page" do
      @controller = mock('controller', :controller_name => 'posts', :action_name => 'index')
      document_title.should == Soapbox['blog_title']
    end
    
    it "should default to the blog name on a non blog entry page and page title is not set" do
      @controller = mock('controller', :controller_name => 'posts', :action_name => 'by_year')
      document_title.should == Soapbox['blog_title']
    end
    
    it "should display <post_title> <seperator> <blog title> when viewing blog post" do
      @controller = mock('controller', :controller_name => 'posts', :action_name => 'show')
      @page = {:title => "Testing 123"} 
      document_title.should == "Testing 123 - #{Soapbox['blog_title']}"
    end
    
    it "should use the specified seperator" do
      @controller = mock('controller', :controller_name => 'posts', :action_name => 'show')
      @page = {:title => "Testing 123"} 
      document_title('::').should == "Testing 123 :: #{Soapbox['blog_title']}"
    end
    
    it "should display page name for a non blog entry page" do
      @controller = mock('controller', :controller_name => 'posts', :action_name => 'archives')
      @page = {:title => "Archives"}
      document_title.should == "Archives - #{Soapbox['blog_title']}"
    end
  end

end
