require 'rack/test'
require 'rspec'
require 'webmock/rspec'
require_relative '../app.rb'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods

  def app
    MonitoringAgent
  end
end

RSpec.configure { |c| c.include RSpecMixin }
