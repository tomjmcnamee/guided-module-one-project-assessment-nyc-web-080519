require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_relative '../lib/models/list_utilities.rb'
require_all 'lib'

require_relative '../lib/golfer_app.rb'