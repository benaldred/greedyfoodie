class Post < CouchRest::ExtendedDocument
  use_database DB
  include ::CouchRest::Validation
  
  view_by :created_at, :descending => true
  
  view_by :published,
    :map =>
     "function(doc) {
       if (doc['couchrest-type'] == 'Post') {
        emit(doc['_id'],1);
       }
     }"
  
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
    self['permalink'] = generate_unique_permalink_from_title
    
    unless new_record?
      id = self['_id']
      self['_id'] = self['permalink']
      # remove old doc
      post = Post.get(id)
      post.destroy
    end
    
  end
  
  
  # generates a unique permalink from the title
  def generate_unique_permalink_from_title(postfix=1)
    
    permalink = title.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
    permalink = permalink + "-#{postfix}" if postfix > 1
    
    # check to see if its unique
    if Post.exists?(permalink)
      generate_unique_permalink_from_title(postfix+1)
    else
      return permalink
    end
  end
  
  def set_timestamps
    self['updated_at'] = Time.now
    self['created_at'] = self['updated_at'] if self.new_document? && self['created_at'].nil?
  end
  
  
  def draft?
    self['status'] == 'draft'
  end
  
  # Class Methods
  # -------------------------------------------------------
  
  # TODO see if there is a really quick way to check in couch to see if an item exists
  def self.exists?(id)
    !get(id).nil?
  end
  
end