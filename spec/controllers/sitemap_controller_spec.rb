require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitemapController do

  def mock_post(stubs={})
    @mock_post ||= mock(Post, stubs)
  end
  
  describe "GET 'index'" do
    describe "with mime type of xml" do
      it "should be successful" do
        get :index, :format => "xml"
        response.should be_success
      end
      
      it "assigns collection for the view" do
        Post.stub!(:by_published).and_return([mock_post])
        get :index, :format => "xml"
        assigns[:posts].should == [mock_post]
      end
    end
  end
end
