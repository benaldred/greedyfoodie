CouchDB = YAML.load_file("#{RAILS_ROOT}/config/couchdb.yml")[RAILS_ENV]     
require 'couchrest'
SERVER = CouchRest.new
DB = SERVER.database!(CouchDB['database'])