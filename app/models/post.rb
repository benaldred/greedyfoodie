class Post < CouchRest::ExtendedDocument
  use_database DB
  include ::CouchRest::Validation
  
  unique_id :permalink
  
  property :title
  property :body
  property :status, :default => 'draft'
  property :permalink
  timestamps!
  
  save_callback :before, :generate_permalink_from_title
  
  validates_present :title, :body
  
  # may need better generation - unique link checking, special chars
  def generate_permalink_from_title(postfix=1)
    
    id = self['_id']
    self['permalink'] = title.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
    self['permalink'] = self['permalink'] + "-#{postfix}" if postfix > 1
    
    # check to see if its unique
    if Post.exists?(self['permalink'])
      generate_permalink_from_title(postfix+1)
    else
      unless new_record? 
        self['_id'] = self['permalink']
        # remove old doc
        post = Post.get(id)
        post.destroy
      end 
      return true
    end
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