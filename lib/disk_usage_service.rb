require_relative 'http_api_service'

class DiskUsageService < HttpApiService
  attr_reader :amount, :ratio

  def initialize(base_url:, client_id:, client_secret:, amount:, ratio:)
    @amount = amount
    @ratio  = ratio
    super(base_url: base_url, client_id: client_id, client_secret: client_secret)
  end

  def call
    puts Time.now
    post
    puts "#{amount} Gigabytes Used"
    puts "#{ratio} Perventage of Gigabytes Used"
    puts "---\n\n"
  rescue ServiceResponseError => e
    puts "DiskUsageService #{e.status}"
  end

  def path
    '/disk_usages'
  end

  def payload
    { disk_usage: { amount: amount, ratio: ratio } }
  end
end
