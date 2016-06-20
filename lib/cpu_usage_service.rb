require_relative 'http_api_service'

class CpuUsageService < HttpApiService
  attr_reader :amount

  def initialize(base_url:, client_id:, client_secret:, amount:)
    @amount = amount
    super(base_url: base_url, client_id: client_id, client_secret: client_secret)
  end

  def call
    puts Time.now
    post
    puts "#{amount}% CPU Used"
    puts "---\n\n"
  rescue ServiceResponseError => e
    puts "CpuUsageService #{e.status}"
  end

  def path
    '/cpu_usages'
  end

  def payload
    { cpu_usage: { amount: amount } }
  end
end
