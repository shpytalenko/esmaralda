# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_esmeralda_session',
  :secret      => '3838e28fd0224c30df3ea6afa3d64fd53e4e3598854cbafe1152a7bf8d3947803ebcf46797b070c1bf6698b6a895f8ed1b3f7d9358d5794ff7c7a2faea0bb7e1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
