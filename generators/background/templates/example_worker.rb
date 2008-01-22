# Simple, non-monitored worker, for those who don't believe in multi-threading.
class ExampleWorker
  
  def add(a, b)
    a + b
  end

end

# Bonus features available if allow_concurrency is set to true!
# Remeber to inherit from Background::MonitoredWorker.
# Every place where record_progress is invoked is a possible stopping place.
class ExampleMonitoredWorker < Background::MonitoredWorker
  
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