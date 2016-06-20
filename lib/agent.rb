require 'rufus-scheduler'
require 'usagewatch_ext'

class Agent

  def initialize(client_id:, client_secret:)
    @client_id     = client_id
    @client_secret = client_secret
    @scheduler     = Rufus::Scheduler.new
    @watcher       = Usagewatch
    @job           = nil
  end

  def start
    stop
    @job = @scheduler.every '3s' do
      puts Time.now
      puts "#{@watcher.uw_diskused} Gigabytes Used"
      puts "#{@watcher.uw_diskused_perc} Perventage of Gigabytes Used"
      puts "#{@watcher.uw_cpuused}% CPU Used"
      puts "#{@watcher.uw_memused}% Active Memory Used"
      puts "#{@watcher.uw_load} Average System Load Of The Past Minute"
      puts "Top Ten Processes By CPU Consumption: #{@watcher.uw_cputop}"
      puts "Top Ten Processes By Memory Consumption: #{@watcher.uw_memtop}"
      puts "---\n\n"
    end
  end

  def stop
    @scheduler.unschedule @job if @job
  end
end
