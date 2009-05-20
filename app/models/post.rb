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
  
  # may need better generation - unique link checking, specia chars
  def generate_permalink_from_title
    self['permalink'] = title.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'') if new_document?
  end
  
end