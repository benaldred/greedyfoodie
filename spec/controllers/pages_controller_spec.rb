require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  
  it "should maps root" do
    route_for(:controller => "pages", :action => "show", :page => 'about').should == "/about"
  end
  
  it "generates params for #show" do
    params_from(:get, "/about").should == {:controller => "pages", :action => "show", :page => "about"}
  end

  
  before(:each) do
    # minimal spec to check the before filter runs
    #controller.should_receive(:setup_sidebar).once.and_return(true)
  end
  

  
  describe "GET 'show'" do
    it "should be successful" do
      get :show, :page => "about"
      response.should be_success
    end
    
    it "should render the correct template" do
      get :show, :page => "about"
      response.should render_template('about')
    end
  end
  


end