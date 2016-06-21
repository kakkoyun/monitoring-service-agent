require 'sinatra'
require 'logger'
require 'yaml'
require_relative 'lib/agent'

use Rack::Logger

class MonitoringAgent < Sinatra::Base

  use Rack::Auth::Basic, "Protected Area" do |username, password|
    secrets             = YAML.load_file('config/secrets.yml')
    environment_secrets = secrets.fetch(settings.environment.to_s)
    stored_username     = environment_secrets.fetch("username")
    stored_password     = environment_secrets.fetch("password")
    username == stored_username && password == stored_password
  end

  helpers do
    def logger
      request.logger
    end
  end

  configure do
    # Disable concurrent requests.
    set :lock, true

    # Read secrets from config file.
    secrets             = YAML.load_file('config/secrets.yml')
    environment_secrets = secrets.fetch(settings.environment.to_s)
    server_base_url     = environment_secrets.fetch("server_base_url")
    client_id           = environment_secrets.fetch("client_id")
    client_secret       = environment_secrets.fetch('client_secret')
    unless client_id || client_secret || server_base_url
      logger.info "Missing configuration. You need to provide server address and OAuth Credentials."
      Process.kill("KILL", Process.pid)
    end

    # Enable file logging.
    enable :logging
    file      = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    # Initialize own loagger.
    logger                 = Logger.new file
    logger.level           = Logger::INFO
    logger.datetime_format = '%a %d-%m-%Y %H%M '
    set :logger, logger

    # Initialize agent.
    set :agent, Agent.new(base_url:      server_base_url,
                          client_id:     client_id,
                          client_secret: client_secret,
                          logger:        logger)

    unless settings.environment.to_s == "test"
      agent.start
    end
  end

  get '/' do
    "Welcome to Monitoring Service client-side agent."
  end

  get '/start' do
    settings.agent.start
    "Agent started."
  end

  get '/stop' do
    settings.agent.stop
    "Agent stopped."
  end

  get '/kill' do
    Thread.new {
      sleep 5
      Process.kill("KILL", Process.pid)
    }
    "I'll lilling myself in 5!"
  end
end
