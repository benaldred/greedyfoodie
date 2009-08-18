require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SyndicationController do

  def mock_post(stubs={})
    @mock_post ||= mock(Post, stubs)
  end
  
  describe "GET 'sitemap'" do
    describe "with mime type of xml" do
      it "should be successful" do
        get :sitemap, :format => "xml"
        response.should be_success
      end
      
      it "assigns collection for the view" do
        Post.stub!(:by_published).and_return([mock_post])
        get :sitemap, :format => "xml"
        assigns[:posts].should == [mock_post]
      end
    end
  end
  
  describe "GET 'feed'" do
    it "should be successful" do
      get :feed, :format => "rss"
      response.should be_success
    end
    
    it "should assign collection of posts grouped by month as @posts" do
      Post.stub!(:by_published).and_return([mock_post])
      get :feed, :format => "rss"
      assigns[:posts].should == [mock_post]
    end
  end
end
