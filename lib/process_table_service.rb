require_relative 'http_api_service'

class ProcessTableService < HttpApiService
  attr_reader :process_table

  def initialize(base_url:, client_id:, client_secret:, logger:, process_table:)
    @process_table = process_table
    super(base_url: base_url, client_id: client_id, client_secret: client_secret, logger: logger)
  end

  def call
    logger.info Time.now
    logger.info "Top Ten Processes By CPU Consumption: #{process_table}"
    logger.info "---\n\n"
    post
  end

  def path
    '/process_tables'
  end

  def payload
    {
        process_table: {
            process_table_items_attributes: process_table.map do |name, usage|
              { name: name, cpu_usage_amount: usage }
            end
        }
    }
  end
end
