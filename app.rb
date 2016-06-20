require 'sinatra/base'
require 'yaml'
require_relative 'lib/agent'


class MonitoringAgent < Sinatra::Base

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
      puts "Missing configuration. You need to provide server address and OAuth Credentials."
      Process.kill("KILL", Process.pid)
    end

    # Initialize agent.
    set :agent, Agent.new(client_id: client_id, client_secret: client_secret)
    agent.start
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
