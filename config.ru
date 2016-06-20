require 'rubygems'
require 'bundler'
Bundler.require

require File.absolute_path("app.rb")

run MonitoringAgent
