require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PostsController do
  
  it "should maps root" do
    route_for(:controller => "posts", :action => "index").should == "/"
  end


end