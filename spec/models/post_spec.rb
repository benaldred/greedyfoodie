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
  
  it "draft? should return true if post is a draft" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.draft?.should == true
  end
  
  it "published? should return false if post is a draft" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.published?.should == false
  end
  
  it "draft? should return false if post is not a draft" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.status = "published"
    @post.draft?.should == false
  end
  
  it "published? should return true if post is a published" do
    @post = Post.create!(:title => "title one", :body => "The best blog post in the world")
    @post.status = "published"
    @post.published?.should == true
  end
  
  describe "year_and_month method" do
    it "should return the year and month as numbers" do
       @post = Post.create!(:title => "title one", :body => "The best blog post in the world", :created_at => "2009/06/24 14:10:27 +0000")
       @post.year_and_month.should == ["2009", "06"]
    end
  end
  
  describe "verify date" do
    it "should return true if the posts date matches given values" do
      @post = Post.create!(:title => "title one", :body => "The best blog post in the world", :created_at => "2009/06/24 14:10:27 +0000")
      @post.verify_date?(:year => "2009", :month => "06").should == true
    end

    it "should return false if the posts month differs from given value" do
      @post = Post.create!(:title => "title one", :body => "The best blog post in the world", :created_at => "2009/06/24 14:10:27 +0000")
      @post.verify_date?(:year => "2009", :month => "10").should == false
    end

    it "should return false if the posts year differs from given value" do
      @post = Post.create!(:title => "title one", :body => "The best blog post in the world", :created_at => "2009/06/24 14:10:27 +0000")
      @post.verify_date?(:year => "2002", :month => "06").should == false
    end
  end
  
  describe "find_by..." do
    
    before do
      reset_test_db!
      Post.create!(:title => "title one", :body => "The best blog post in the world", :created_at => "2009/06/24 14:10:27 +0000", :status => 'published')
      Post.create!(:title => "title two", :body => "The best blog post in the world", :created_at => "2008/06/24 14:10:27 +0000", :status => 'published')
    end
    
    it "_year should find posts by its year" do
      @posts = Post.find_by_year('2009')
      @posts.size.should == 1
    end
    
    it "_year_and_month should find posts by its year and month" do
      @posts = Post.find_by_year_and_month('2009', '06')
      @posts.size.should == 1
    end
  end
end