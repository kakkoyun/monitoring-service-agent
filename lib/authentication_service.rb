require 'json'
require_relative 'http_api_service'

class AuthenticationService

  def initialize(base_url:, client_id:, client_secret:)
    @client_id     = client_id
    @client_secret = client_secret
    @base_url      = base_url
    @retry_count   = 3
  end

  def call
    @@access_token ||= begin
      if @retry_count > 0
        if (authentication_response = post)
          @retry_count = 3
          access_token = authentication_response.access_token
          puts "Access Token #{access_token}"
          access_token
        else
          # TODO: Check unauthorized.
          @retry_count -=1
          call
        end
      else
        puts "Retry Count exceeded!"
        raise UnauthorizedError
      end
    end
  rescue UnauthorizedError => e
    # TODO: !!
    puts 'Lost connection with server.'
    Process.kill("KILL", Process.pid)
  end

  class UnauthorizedError < RuntimeError

  end

  private

  def connection
    Faraday.new(url: @base_url)
  end

  def post
    response = connection.post "/oauth/token",
                               { client_id:     @client_id,
                                 client_secret: @client_secret,
                                 grant_type:    'client_credentials'
                               }
    if response.success?
      JSON.parse(response.body, symbolize_names: true, object_class: OpenStruct)
    end
  end
end
