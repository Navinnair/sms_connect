# Load the Rails application.
require_relative 'application'

# pluralize_table_names, db dump consists of db with singular name
ActiveRecord::Base.pluralize_table_names = false

# Initialize the Rails application.
Rails.application.initialize!

