# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_soapbox_session',
  :secret      => '06281506a3ce5a07fb84b016804fced9a22778400b11959b9842a8b677d13a015f4dc89d4577ecf3217c2cb763429726e39c5c49e0d575b13aa92c1cb1fcbfd9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
