#!/usr/bin/env ruby
#ENV["SINATRA_ENV"] ||= "development"

require_relative '../config/environment'
require_all 'lib'

GolferApp.new.call
