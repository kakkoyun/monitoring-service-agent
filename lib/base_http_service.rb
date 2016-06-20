require 'json'

class BaseHttpService
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
    response = connection.post "/api/v1#{path}", payload
    if response.success?
      JSON.parse response.body
    else
      raise ServiceResponseError(status: response.status)
    end
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
