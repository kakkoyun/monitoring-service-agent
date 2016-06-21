class HttpService
  attr_reader :base_url, :client_id, :client_secret, :logger

  def initialize(base_url:, client_id:, client_secret:, logger:)
    @client_id     = client_id
    @client_secret = client_secret
    @base_url      = base_url
    @logger        = logger
  end

  def call
    throw NotImplementedError
  end

  class Error < RuntimeError
    attr_reader :status

    def initialize(message = nil, status:)
      @status = status
      super(message)
    end
  end

  class ResponseError < Error
  end

  class UnauthorizedError < Error

    def initialize(message = nil)
      super(message, status: 401)
    end
  end

  protected

  def connection
    Faraday.new(url: base_url)
  end
end
