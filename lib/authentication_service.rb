require 'json'
require_relative 'http_service'

class AuthenticationService < HttpService
  attr_reader :logger

  def initialize(base_url:, client_id:, client_secret:, logger:)
    @retry_count = 3
    super(base_url: base_url, client_id: client_id, client_secret: client_secret, logger: logger)
  end

  def call
    @@access_token ||= begin
      if @retry_count > 0
        if (authentication_response = post)
          @retry_count = 3
          access_token = authentication_response.access_token
          logger.info "Access Token #{access_token}"
          access_token
        else
          # TODO: Check unauthorized.
          @retry_count -=1
          call
        end
      else
        logger.info "Retry Count exceeded!"
        raise UnauthorizedError
      end
    end
  rescue UnauthorizedError => e
    # TODO: !!
    logger.info 'Lost connection with server.'
    Process.kill("KILL", Process.pid)
  end

  private

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
