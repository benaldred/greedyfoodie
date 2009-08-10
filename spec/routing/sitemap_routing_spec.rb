require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitemapController do
  describe "route generation" do
    it "should map index" do
      route_for(:controller => "sitemap", :action => "index", :format => "xml").should == "/sitemap.xml"
    end
  end
  
  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/sitemap.xml").should == {:controller => "sitemap", :action => "index", :format => "xml"}
    end
  end
end