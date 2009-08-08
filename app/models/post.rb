class Post < CouchRest::ExtendedDocument
  use_database DB
  include ::CouchRest::Validation
  
  # -------------------
  #  Properties
  # -------------------
  
  unique_id :permalink
  
  property :title
  property :body
  property :status, :default => 'draft'
  property :permalink
  property(:updated_at, :read_only => true, :cast_as => 'Time', :auto_validation => false)
  property(:created_at, :read_only => true, :cast_as => 'Time', :auto_validation => false)
  
  save_callback :before, :set_permalink_from_title
  save_callback :before, :set_timestamps
  
  validates_present :title, :body
  
  def set_permalink_from_title

    self['permalink'] = generate_unique_permalink_from_title if new_record? || title_changed?
    
    # if the title has changed and its an edit
    # set a new id and clean up the old doc
    # TODO look at copy method in couch rest
    cleanup_old_doc if title_changed? and not new_record?  
  end
  
  # generates a unique permalink from the title
  def generate_unique_permalink_from_title(postfix=1)
    
    permalink = title_to_permalink(title)
    permalink = "#{permalink}-#{postfix}" if postfix > 1
    

    # if post exists call again adding postfix
    # if currnt post exists then it will find itself anf +1
    if Post.exists?(permalink)
      generate_unique_permalink_from_title(postfix+1) 
    else
     return permalink
    end
  end
  
  # -------------------
  #  Views
  # -------------------
  
  view_by :created_at, :descending => true
  view_by :status, :created_at, :descending => true
  
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
     }"

  def self.find_by_year(year)
    year = year.to_i
    self.by_published(:startkey => [year,12,31], :endkey => [year,1,1])
  end
  
  def self.find_by_year_and_month(year, month)
    month = month.to_i
    year = year.to_i
    self.by_published(:startkey => [year,month,Time.days_in_month(month)], :endkey => [year,month,1])
  end
  
  def self.exists?(id)
    !get(id).nil?
  end
  
  def set_timestamps
    self['updated_at'] = Time.now
    self['created_at'] = self['updated_at'] if self.new_document? && self['created_at'].nil?
  end
  
  
  def draft?
    self['status'] == 'draft'
  end
  
  def published?
    self['status'] == 'published'
  end
  
  def year_and_month
    [self['created_at'].year.to_s, self['created_at'].strftime("%m")]
  end
  
  def verify_date?(options = {})
    (self['created_at'].year.to_s == options[:year]) && (self['created_at'].strftime("%m") == options[:month])
  end
  
  private
  
  def cleanup_old_doc
    # store the old id 
    id = self['_id']
    
    #keep the same doc but set a new id
    self['_id'] = self['permalink']
    
    # remove old doc
    post = Post.get(id)
    post.destroy
  end
  
  def title_changed?
    (self['_id'] != title_to_permalink(self['title']))
  end
  
  def title_to_permalink(text)
    text.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
  end
  
end