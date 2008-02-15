# Include it in your workers to enable progress monitoring, stopping/restarting jobs.
# You also have to allow_concurrency in ActiveRecord to make this work.
module BackgroundFu::WorkerMonitoring
    
  def record_progress(progress)
    @progress = progress.to_i
    throw(:stopped) if @should_stop
  end

end
