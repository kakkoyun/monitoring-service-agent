require 'rufus-scheduler'
require 'usagewatch_ext'

require_relative 'cpu_usage_service'
require_relative 'disk_usage_service'
require_relative 'process_table_service'

class Agent

  def initialize(client_id:, client_secret:)
    @scheduler = Rufus::Scheduler.new
    @watcher   = Usagewatch
    @jobs      = []

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
      puts Time.now
      CpuUsageService.new(client_id:     @client_id,
                          client_secret: @client_secret,
                          amount:        @watcher.uw_cpuused).call
      puts "#{@watcher.uw_cpuused}% CPU Used"
      puts "---\n\n"
    end
  end

  def schedule_disk_usage_job
    @scheduler.every '3s' do
      puts Time.now
      DiskUsageService.new(client_id:     @client_id,
                           client_secret: @client_secret,
                           amount:        @watcher.uw_diskused,
                           ratio:         @watcher.uw_diskused_perc).call
      puts "#{@watcher.uw_diskused} Gigabytes Used"
      puts "#{@watcher.uw_diskused_perc} Perventage of Gigabytes Used"
      puts "---\n\n"
    end
  end

  def schedule_process_table_job
    @scheduler.every '3s' do
      puts Time.now
      ProcessTableService.new(client_id:     @client_id,
                              client_secret: @client_secret,
                              process_table: @watcher.uw_cputop).call
      puts "Top Ten Processes By CPU Consumption: #{@watcher.uw_cputop}"
      puts "---\n\n"
    end
  end
end
