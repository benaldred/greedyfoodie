Soapbox = YAML.load_file("#{RAILS_ROOT}/config/soapbox.yml")[RAILS_ENV]
CouchDB = YAML.load_file("#{RAILS_ROOT}/config/couchdb.yml")[RAILS_ENV] 