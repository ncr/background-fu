module Background
  
  def self.jobs
    @@jobs ||= Jobs.new
  end

  class Jobs
    
    def new(*args)
      Job.new(*args)
    end

    def create!(worker_class, worker_method, *args)
      Job.create!(
        :worker_class  => worker_class.to_s,
        :worker_method => worker_method.to_s,
        :args          => args
      )
    end

    def create(worker_class, worker_method, *args)
      Job.create(
        :worker_class  => worker_class.to_s,
        :worker_method => worker_method.to_s,
        :args          => args
      )
    end

    def find(id)
      Job.find(id)
    end

    def find_by_id(id)
      Job.find_by_id(id)
    end

    def find_in_state(state)
      Job.find_by_state(state, :order => "created_at")
    end

    def find_all_in_state(state)
      Job.find_all_by_state(state, :order => "created_at")
    end
    
    def method_missing(method, *args, &block)
      Job.find(:all, :order => "created_at").send!(method, *args, &block)
    end
    
  end

  class Job < ActiveRecord::Base

    States = %w(pending running stopping finished failed)

    serialize :args, Array
    serialize :result

    before_validation_on_create :setup_state

    validates_inclusion_of :state, :in => States
    validates_presence_of :worker_class, :worker_method

    # Every call to these methods fetches fresh state value from db.
    States.each do |state_name|
      define_method("#{state_name}?") do
        reload.state == state_name
      end
    end

    def get_done!
      update_attribute(:state, "running")
      @worker = worker_class.constantize.new
      monitor_progress!
      self.result = @worker.send!(worker_method, *args)
      self.state = "finished"
    rescue 
      self.state = "failed"
    ensure
      save(false)
      cleanup_after_threads!
    end
    
    # When multithreading is enabled, you can ask a worker to terminate a job.
    # Worker should periodically check if @should_stop is true and return if possible.
    def stop!
      if running? && Background.multi_threaded?
        update_attribute(:state, "stopping")
      end
    end

    private

    # Don't get scared. ActiveRecord IS thread-safe.
    # To enable progress monitoring you have to manually
    # set ActiveRecord::Base.allow_concurrency to true.
    # in lib/daemons/background.rb.
    # This is the only place where multi-threading occurs
    # in the plugin. Progress monitoring is optional.
    def monitor_progress!
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

      end if Background.multi_threaded?
    end

    # Closes database connections left after finished threads.
    def cleanup_after_threads!
      ActiveRecord::Base.verify_active_connections! if Background.multi_threaded?
    end

    def setup_state
      return unless state.blank?

      self.state = "pending" 
    end

  end  

  # Threads are optional. When enabled, they provide
  # the ability to monitor job progress. 
  def self.multi_threaded?
    ActiveRecord::Base.allow_concurrency
  end

end
