require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require File.absolute_path("app.rb")

run MonitoringAgent
