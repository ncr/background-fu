class ExampleMonitoredWorker
  
  # After including woker monitoring you can invoke record_progress() method.
  include BackgroundFu::WorkerMonitoring
  
  def long_and_monitored
    my_progress = 0
    
    record_progress(my_progress)

    while(my_progress < 100)
      my_progress += 1
      record_progress(my_progress)
      sleep 1
    end
    
    record_progress(100)
  end
  
end