require 'rufus-scheduler'
require 'usagewatch_ext'

require_relative 'cpu_usage_service'
require_relative 'disk_usage_service'
require_relative 'process_table_service'

class Agent

  def initialize(base_url:, client_id:, client_secret:)
    @scheduler = Rufus::Scheduler.new
    @watcher   = Usagewatch
    @jobs      = []

    @base_url      = base_url
    @client_id     = client_id
    @client_secret = client_secret
  end

  def start
    stop
    @jobs << schedule_cpu_usage_job
    @jobs << schedule_disk_usage_job
    @jobs << schedule_process_table_job
  end

  def stop
    @jobs.each do |job|
      @scheduler.unschedule job
    end
  end

  private


  def schedule_cpu_usage_job
    @scheduler.every '3s' do
      CpuUsageService.new(base_url:      @base_url,
                          client_id:     @client_id,
                          client_secret: @client_secret,
                          amount:        @watcher.uw_cpuused).call

    end
  end

  def schedule_disk_usage_job
    @scheduler.every '3s' do
      DiskUsageService.new(base_url:      @base_url,
                           client_id:     @client_id,
                           client_secret: @client_secret,
                           amount:        @watcher.uw_diskused,
                           ratio:         @watcher.uw_diskused_perc).call
    end
  end

  def schedule_process_table_job
    @scheduler.every '3s' do
      ProcessTableService.new(base_url:      @base_url,
                              client_id:     @client_id,
                              client_secret: @client_secret,
                              process_table: @watcher.uw_cputop).call
    end
  end
end
