require 'json'
require 'faraday'
require_relative 'http_service'
require_relative 'authentication_service'

class HttpApiService < HttpService

  protected

  def post
    response = connection.post url, payload do |req|
      req.headers['Authorization'] = "Bearer #{authentication_service.call}"
    end
    if response.success?
      JSON.parse(response.body, symbolize_names: true, object_class: OpenStruct)
    else
      raise ResponseError.new(status: response.status)
    end
  end

  def authentication_service
    @authentication_service ||= AuthenticationService.new(base_url:      base_url,
                                                          client_id:     client_id,
                                                          client_secret: client_secret,
                                                          logger:        logger)
  end

  def url
    "/api/v1#{path}"
  end

  def path
    throw NotImplementedError
  end

  def payload
    throw NotImplementedError
  end
end
