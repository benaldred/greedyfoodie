require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do

  def mock_post(stubs={})
    @mock_post ||= mock(Post, stubs)
  end


  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    
    it "assigns collection for the view" do
      Post.stub!(:by_latest_published).and_return([mock_post])
      get :index
      assigns[:posts].should == [mock_post]
    end
  end

end
