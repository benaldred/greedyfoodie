require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsHelper do
  include PostsHelper
  
  def mock_post(stubs={})
    @mock_post ||= mock(Post, stubs)
  end
  
  it "link_to_post should return a full permalink for a post" do
    @post = mock_post(:permalink => "a-title", :year_and_month => ["2009", "06"], :title => "a title")
    link_to_post(@post).should == '<a href="2009/06/a-title">a title</a>'
  end
  
  describe "display the posts date" do
    it "should display nicely formatted date" do
      @post = mock_post(:created_at => "2008/06/24 14:10:27 +0000", :new_record? => false)
      post_date(@post).should == "24 June 2008"
    end
    
    it "should display todays date for new post (used in preview)" do
      @post = mock_post(:created_at => nil, :new_record? => true)
      post_date(@post).should == l(Time.now, :format => :long)
    end
  end
  
  describe "display post sums next to months and years" do
    it "should generate list items" do
      @post_sum_by_month = {"rows"=>[{"value"=>1, "key"=>[2009, 8]}, {"value"=>1, "key"=>[2009, 6]}]}
      by_month_list(@post_sum_by_month).should == "<li><a href=\"/2009/08\">August 2009</a> <span>1</span></li>\n  <li><a href=\"/2009/06\">June 2009</a> <span>1</span></li>"     
    end
  end
end
