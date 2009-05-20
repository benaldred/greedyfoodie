require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Post do
  before(:each) do
    @post = Post.new(:title => "my title", :body => "The best blog post in the world")
  end

  it "should create a valid post" do
    @post.should be_valid
  end
  
  it "should not be valid without a title" do
    @post.title = nil
    @post.should_not be_valid
    @post.errors.on(:title).first.should == "Title must not be blank"
  end
  
  it "should not be valid without a body" do
    @post.body = nil
    @post.should_not be_valid
    @post.errors.on(:body).first.should == "Body must not be blank"
  end
  
  it "should store a default state as draft" do
    @post.status.should == "draft"
  end
  
  it "should create the correct permalink" do
    @post.title = "a really long title"
    @post.save!
    @post.permalink.should == "a-really-long-title"
  end
  
  it "should create permalink from strange title" do
    @post.title = "a double  spaced 'quouted' title with & and ?"
    @post.save!
    @post.permalink.should == "a-double-spaced-quouted-title-with-and"
  end
  
  it "should create unique permalinks" 
end