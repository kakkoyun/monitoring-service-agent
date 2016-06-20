require_relative 'base_agent_service'

class ProcessTableService < BaseAgentService
  attr_reader :process_table

  def initialize(client_id:, client_secret:, process_table:)
    @process_table = process_table
    super(client_id: client_id, client_secret: client_secret)
  end

  def call
    puts process_table
  end
end
