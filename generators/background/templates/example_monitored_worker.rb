# Remember to enable allow_concurrency in your environment 
# and include Background::WorkerMonitoring.
# Every place where record_progress is invoked is a possible stopping place.
class ExampleMonitoredWorker
  
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