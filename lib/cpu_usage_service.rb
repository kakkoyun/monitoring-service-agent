require_relative 'base_agent_service'

class CpuUsageService < BaseAgentService
  attr_reader :amount

  def initialize(client_id:, client_secret:, amount:)
    @amount = amount
    super(client_id: client_id, client_secret: client_secret)
  end

  def call
    puts amount
  end
end
