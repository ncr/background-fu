# Include it in your workers to enable progress monitoring and stopping jobs.
module BackgroundFu::WorkerMonitoring
    
  # In most cases you will have some loop which will execute known (m) times.
  # Every time the loop iterates you increment a counter (n).
  # The formula to get progress in percents is: 100 * n / m.
  # If you invoke this method with second argument, then this is calculated for you.
  # You also can omit second argument and progress will be passed directly to db.
  def record_progress(progress_or_iteration, iterations_count = nil)
    if iterations_count.to_i > 0
      @progress = ((progress_or_iteration.to_f / iterations_count) * 100).to_i
    else
      @progress = progress_or_iteration.to_i
    end

    throw(:stopping, true) if @stopping
  end

end
