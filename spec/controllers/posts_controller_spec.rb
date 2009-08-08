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
      Post.stub!(:by_published).and_return([mock_post])
      get :index
      assigns[:posts].should == [mock_post]
    end
  end
  
  describe "GET 'show'" do
    it "should be successful" do
      Post.stub!(:get).and_return(mock_post(:published? => true, :verify_date? => true))
      get :show, :year => "2009", :month => "06", :id => "a-title"
      response.should be_success
    end
    
    it "should assign post as @post" do
      Post.stub!(:get).and_return(mock_post(:published? => true, :verify_date? => true))
      get :show, :year => "2009", :month => "06", :id => "a-title"
      assigns[:post].should == mock_post
    end
    
    it "should redirect unpublished posts to the 404 page" do
      Post.stub!(:get).and_return(mock_post(:published? => false, :verify_date? => true))
      get :show, :year => "2009", :month => "06", :id => "a-title"
      response.should redirect_to('/404')
    end
    
    # we really want to index and cache the correct url
    it "should redirect posts with incorrect dates to 404" do
      Post.stub!(:get).and_return(mock_post(:published? => true, :verify_date? => false))
      get :show, :year => "2009", :month => "06", :id => "a-title"
      response.should redirect_to('/404')
    end
  
  end
  
  describe "GET 'by_year'" do
    it "should be successful" do
      Post.stub!(:find_by_year).and_return([mock_post])
      get :by_year, :year => "2009"
      response.should be_success
    end
    
    it "should assign post as @post" do
      Post.stub!(:find_by_year).and_return([mock_post])
      get :by_year, :year => "2009"
      assigns[:posts].should == [mock_post]
    end
  end
  
  describe "GET 'by_month'" do
    it "should be successful" do
      Post.stub!(:find_by_year_and_month).and_return([mock_post])
      get :by_month, :year => "2009", :month => "09"
      response.should be_success
    end
    
    it "should assign post as @post" do
      Post.stub!(:find_by_year_and_month).and_return([mock_post])
      get :by_month, :year => "2009", :month => "09"
      assigns[:posts].should == [mock_post]
    end
  end

end
