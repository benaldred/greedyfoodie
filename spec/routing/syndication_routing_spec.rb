require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SyndicationController do
  describe "route generation" do
    it "should map sitemap" do
      route_for(:controller => "syndication", :action => "sitemap", :format => "xml").should == "/sitemap.xml"
    end
    
    it "should map feed" do
      route_for(:controller => "syndication", :action => "feed", :format => 'rss').should == "/feed.rss"
    end
  end
  
  describe "route recognition" do
    it "generates params for #sitemap" do
      params_from(:get, "/sitemap.xml").should == {:controller => "syndication", :action => "sitemap", :format => "xml"}
    end
    
    it "generates params for #feed" do
      params_from(:get, "/feed.rss").should == {:controller => "syndication", :action => "feed", :format => "rss"}
    end
  end
end