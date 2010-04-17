# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_donde_estudio_session',
  :secret      => '05fac78b320c19b4a3bea0fbbf53e026d0518ac0471c2f96b17c235236a8c99abc5f1a39da39691224ddb44d49f4943852489e04a505371ea20124ed9cdc4414'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
