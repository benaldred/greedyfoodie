class Post < CouchRest::ExtendedDocument
  use_database DB
  include ::CouchRest::Validation
  
  # -------------------
  #  Properties
  # -------------------
  property :title
  property :body
  property :preview, :default => nil
  property :status, :default => 'draft'
  property :permalink
  property(:updated_at, :read_only => true, :cast_as => 'Time', :auto_validation => false)
  property(:created_at, :read_only => true, :cast_as => 'Time', :auto_validation => false)
  
  save_callback :before, :set_permalink_from_title
  save_callback :before, :set_timestamps

  
  validates_present :title, :body
  #validates_is_unique property.name

  
  def set_permalink_from_title
    self['permalink'] = generate_unique_permalink_from_title if new_record? || title_changed?
  end
  
  # generates a unique permalink from the title
  def generate_unique_permalink_from_title(postfix=1)
    
    permalink = title_to_permalink(title)
    permalink = "#{permalink}-#{postfix}" if postfix > 1

    if Post.permalink_unique?(permalink)
      # permalink is ok and just return
      return permalink 
    else
      # call the same method again with an incremented number
      generate_unique_permalink_from_title(postfix+1)
    end
  end
  
  # alternative constructor that return a new post object with some values set 
  def self.new_from_params(params)
    post = Post.new(params[:post])
    #set the status
    if params[:preview]
      post.status = 'preview'
    end 
    post.status = 'published' if params[:publish]

    post
  end
  
  def set_updated_at(time)
    self['updated_at'] = Time.parse(time)
  end
  
  
  # -------------------
  #  Find by ..
  # -------------------
  
  # will return the first post it finds by the pemalink
  def self.find_by_permalink(permalink)
    Post.by_permalink(:key => permalink).first
  end
  
  def self.find_by_year(year)
    year = year.to_i
    self.by_published(:startkey => [year,12,31], :endkey => [year,1,1])
  end
  
  def self.find_by_year_and_month(year, month)
    month = month.to_i
    year = year.to_i
    self.by_published(:startkey => [year,month,Time.days_in_month(month)], :endkey => [year,month,1])
  end 
  
  # -------------------
  #  Views
  # -------------------
  
  view_by :created_at, :descending => true
  view_by :status, :created_at, :descending => true
  
  view_by :permalink
  
  # exclude preview posts and order by updated_at
  view_by :admin_posts, :descending => true,
    :map =>
     "function(doc) {
       if ((doc['couchrest-type'] == 'Post') && (doc['status'] != 'preview') && doc['updated_at']) {
        emit(doc['updated_at'], 1);
       }
     }"
  
  # it is implied that all published articles are 
  # ordered by date, descending
  view_by :published, :descending => true,
    :map =>
     "function(doc) {
       if ((doc['couchrest-type'] == 'Post') && (doc['status'] == 'published') && doc['created_at']) {
        datetime = doc.created_at;
        year = parseInt(datetime.substr(0, 4));
        month = parseInt(datetime.substr(5, 2), 10);
        day = parseInt(datetime.substr(8, 2), 10);
        emit([year, month, day], 1);
       }
     }",
     :reduce => 
       "function(keys, values, rereduce) {
         return sum(values);
       }"


  
  # sum_by_month
  # 
  # returns
  def self.sum_by_month
    self.by_published :reduce => true, :group_level => 2
  end
  
  
  # -------------------
  #  Before save
  # -------------------
  
  #TODO remove this and use an explicit set for testing
  def set_timestamps
    self['updated_at'] = Time.now
    self['created_at'] = self['updated_at'] if self.new_document? && self['created_at'].nil?
  end  
  
  # check if the permalink is unique
  def self.permalink_unique?(permalink)
    post = Post.find_by_permalink(permalink)
    # previews are temp and not 'real' posts
    post.nil? || (post.status == 'preview')
  end
  

  
  # -------------------
  #  useful methods
  # -------------------
  def draft?
    self['status'] == 'draft'
  end
  
  def published?
    self['status'] == 'published'
  end
  
  def preview?
    self['status'] == 'preview'
  end
  
  def year_and_month
    [self['created_at'].year.to_s, self['created_at'].strftime("%m")]
  end
  
  def url
    year, month = year_and_month
    "#{year}/#{month}/#{permalink}"
  end
  
  def verify_date?(options = {})
    (self['created_at'].year.to_s == options[:year]) && (self['created_at'].strftime("%m") == options[:month])
  end
  
  def title_to_permalink(text)
    text.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
  end
  
  private
  
  def title_changed?
    (self['permalink'] != title_to_permalink(self['title']))
  end
  

  
end