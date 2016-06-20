require 'json'
require_relative 'authentication_service'

class HttpApiService
  attr_reader :base_url, :client_id, :client_secret

  def initialize(base_url:, client_id:, client_secret:)
    @client_id     = client_id
    @client_secret = client_secret
    @base_url      = base_url
  end

  def call
    throw NotImplementedError
  end

  protected

  def connection
    Faraday.new(url: base_url)
  end

  def post
    response = connection.post url, payload do |req|
      req.headers['Authorization'] = "Bearer #{authentication_service.call}"
    end
    if response.success?
      JSON.parse(response.body, symbolize_names: true, object_class: OpenStruct)
    else
      raise ServiceResponseError(status: response.status)
    end
  end

  def authentication_service
    @authentication_service ||= AuthenticationService.new(base_url:      base_url,
                                                          client_id:     client_id,
                                                          client_secret: client_secret)
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

  class Error < RuntimeError
    attr_reader :status

    def initialize(message = nil, status:)
      @status = status
      super(message)
    end
  end

  class ServiceResponseError < Error
  end
end
