require_relative 'http_api_service'

class CpuUsageService < HttpApiService
  attr_reader :amount

  def initialize(base_url:, client_id:, client_secret:, amount:, logger:)
    @amount = amount
    super(base_url: base_url, client_id: client_id, client_secret: client_secret, logger: logger)
  end

  def call
    logger.info Time.now
    post
    logger.info "#{amount}% CPU Used"
    logger.info "---\n\n"
  rescue ServiceResponseError => e
    logger.info "CpuUsageService #{e.status}"
  end

  def path
    '/cpu_usages'
  end

  def payload
    { cpu_usage: { amount: amount } }
  end
end
