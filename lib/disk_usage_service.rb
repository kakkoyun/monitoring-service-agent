require_relative 'http_api_service'

class DiskUsageService < HttpApiService
  attr_reader :amount, :ratio

  def initialize(base_url:, client_id:, client_secret:, amount:, ratio:, logger:)
    @amount = amount
    @ratio  = ratio
    super(base_url: base_url, client_id: client_id, client_secret: client_secret, logger: logger)
  end

  def call
    logger.info Time.now
    post
    logger.info "#{amount} Gigabytes Used"
    logger.info "#{ratio} Perventage of Gigabytes Used"
    logger.info "---\n\n"
  rescue ServiceResponseError => e
    logger.info "DiskUsageService #{e.status}"
  end

  def path
    '/disk_usages'
  end

  def payload
    { disk_usage: { amount: amount, ratio: ratio } }
  end
end
