module Job::BonusFeatures
  
  # Registering callbacks
  def self.included(base)
    base.send!(:define_method, :before_work) do
      monitor_worker
    end

    base.send!(:define_method, :after_work) do
      cleanup_after_threads
    end
  end
  
  # When multithreading is enabled, you can ask a worker to terminate a job.
  #
  # The record_progress() method becomes available when your worker class includes
  # Background::WorkerMonitoring.
  #
  # Every time worker invokes record_progress() is a possible stopping place.
  #
  # How it works:
  # 1. invoke job.stop! to set a state (stopping) in a db
  # 2. Monitoring thread picks up the state change from db
  #    and sets @should_stop to true in the worker.
  # 3. The worker invokes a register_progress() somewhere during execution.
  # 4. The record_progress() method throws :stopped symbol if @should_stop == true
  # 5. The job catches the :stopped symbol and reacts upon it.
  # 6. The job is stopped in a merciful way. No one gets harmed.
  def stop!
    if running?
      update_attribute(:state, "stopping")
    end
  end
  
  def restart!
    if finished? || failed?
      update_attributes(:result => nil, :progress => nil, :state => "pending")
    end
  end

  # Don't get scared. ActiveRecord IS thread-safe.
  # To enable progress monitoring you have to manually
  # set ActiveRecord::Base.allow_concurrency to true
  # in lib/daemons/background.rb.
  # You don't need to enable multi-threading in your Rails app.
  # This is the only place where multi-threading occurs
  # in the plugin. Progress monitoring is optional.
  def monitor_worker
    Thread.new do
      while(running?)
        current_progress = @worker.instance_variable_get("@progress")

        if current_progress == progress 
          sleep 5
        else
          update_attribute(:progress, current_progress)
          sleep 1
        end
      end

      # If stop! was called on running job, worker has @should_stop set to true.
      if(stopping?)
        @worker.instance_variable_set("@should_stop", true)
      end
      
      # Ensure last available progress is saved
      if(finished?)
        update_attribute(:progress, @worker.instance_variable_get("@progress"))
      end
    end
  end

  # Closes database connections left after finished threads.
  def cleanup_after_threads
    ActiveRecord::Base.verify_active_connections!
  end
  
end
