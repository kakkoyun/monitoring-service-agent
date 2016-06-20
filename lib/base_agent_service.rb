require 'json'

class BaseAgentService
  attr_reader :client_id, :client_secret

  def initialize(client_id:, client_secret:)
    @client_id     = client_id
    @client_secret = client_secret
  end

  def call
    throw NotImplementedError
  end
end
