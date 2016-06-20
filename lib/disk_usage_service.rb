require_relative 'base_agent_service'

class DiskUsageService < BaseAgentService
  attr_reader :amount, :ratio

  def initialize(client_id:, client_secret:, amount:, ratio:)
    @amount = amount
    @ratio  = ratio
    super(client_id: client_id, client_secret: client_secret)
  end

  def call
    puts amount
    puts ratio
  end
end
