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
  
  it "should create unique permalinks"  do
    @old = Post.create!(:title => "only unique permalinks", :body => "The best blog post in the world")
    
    @new = Post.create!(:title => "only unique permalinks", :body => "The best blog post in the world")
    @new.permalink.should == "only-unique-permalinks-2"
  end
  
  it "should create unique permalinks for n times"  do
    @post_1 = Post.create!(:title => "only unique permalinks times", :body => "The best blog post in the world")
    @post_2 = Post.create!(:title => "only unique permalinks times", :body => "The best blog post in the world")
    
    @new = Post.create!(:title => "only unique permalinks times", :body => "The best blog post in the world")
    @new.permalink.should == "only-unique-permalinks-times-3"
  end
  
  it "should update the id when title is changed" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.title = "title two"
    @post.save!
    
    Post.get("title-two").should_not == nil
  end
  
  it "should update the permalink when title is changed" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.title = "title two"
    @post.save!
    
    @foo = Post.get("title-two")
    @foo.permalink.should == "title-two"
  end
  
  it "should tidy up old documents when title is changed" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.title = "title two"
    @post.save!
    Post.get("title-one").should == nil
  end
  
  describe "exists? method" do
    it "should return true if document exists" do
      @post.save!
      Post.exists?(@post.id).should == true
    end
    
    it "should return false when document no in db" do
      Post.exists?("random-id-that-does-not-exist").should == false
    end
  end
  
  describe "draft? method" do
    it "should return true if post is a draft" do
      @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
      @post.draft?.should == true
    end
    
    it "should return true if post is not a draft" do
      @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
      @post.status = "publised"
      @post.draft?.should == false
    end
  end
end