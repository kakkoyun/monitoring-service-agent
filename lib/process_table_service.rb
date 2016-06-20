require_relative 'base_http_service'

class ProcessTableService < BaseHttpService
  attr_reader :process_table

  def initialize(base_url:, client_id:, client_secret:, process_table:)
    @process_table = process_table
    super(base_url: base_url, client_id: client_id, client_secret: client_secret)
  end

  def call
    puts Time.now
    post
    puts "Top Ten Processes By CPU Consumption: #{process_table}"
    puts "---\n\n"
  rescue ServiceResponseError => e
    puts "ProcessTableService #{e.status}"
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
