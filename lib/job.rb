# Example:
# 
# job = Job.enqueue!(MyWorker, :my_method, "my_arg_1", "my_arg_2")
class Job < ActiveRecord::Base

  cattr_accessor :states
  self.states = %w(pending running finished failed)

  serialize :args, Array
  serialize :result

  before_create :setup_state, :setup_priority, :setup_start_at
  validates_presence_of :worker_class, :worker_method
  
  attr_readonly :worker_class, :worker_method, :args
  
  def self.enqueue!(worker_class, worker_method, *args)
    job = create!(
      :worker_class  => worker_class.to_s,
      :worker_method => worker_method.to_s,
      :args          => args
    )

    logger.info("BackgroundFu: Job enqueued. Job(id: #{job.id}, worker: #{worker_class}, method: #{worker_method}, argc: #{args.size}).")
    
    job
  end

  # Invoked by a background daemon.
  def get_done!
    initialize_worker
    invoke_worker
  rescue Exception => e
    rescue_worker(e)
  ensure
    ensure_worker
  end
  
  # Restart a failed job.
  def restart!
    if failed? 
      update_attributes!(
        :result     => nil, 
        :progress   => nil, 
        :started_at => nil, 
        :state      => "pending"
      )
      logger.info("BackgroundFu: Job restarted. Job(id: #{id}).")
    end
  end
  
  def initialize_worker
    update_attributes!(:started_at => Time.now, :state => "running")
    @worker = worker_class.constantize.new
    logger.info("BackgroundFu: Job initialized. Job(id: #{id}).")
  end
  
  def invoke_worker
    self.result = @worker.send(worker_method, *args)
    self.state  = "finished"
    logger.info("BackgroundFu: Job finished. Job(id: #{id}).")
  end
  
  def rescue_worker(exception)
    self.result = [exception.message, exception.backtrace.join("\n")].join("\n\n")
    self.state  = "failed"
    logger.info("BackgroundFu: Job failed. Job(id: #{id}).")
  end
  
  def ensure_worker
    self.progress = @worker.instance_variable_get("@progress")
    save!
  rescue StaleObjectError
    # Ignore this exception as its only purpose is
    # not allowing multiple daemons execute the same job.
    logger.info("BackgroundFu: Race condition handled (It's OK). Job(id: #{id}).")
  end

  def self.generate_state_helpers
    states.each do |state_name|
      define_method("#{state_name}?") do
        state == state_name
      end

      # Job.running => array of running jobs, etc.
      self.class.send!(:define_method, state_name) do
        find_all_by_state(state_name, :order => "id desc")
      end
    end
  end
  generate_state_helpers

  def setup_state
    return unless state.blank?

    self.state = "pending" 
  end
  
  # Default priority is 0. Jobs will be executed in descending priority order (negative priorities allowed).
  def setup_priority
    return unless priority.blank?
    
    self.priority = 0
  end
  
  # Job will be executed after this timestamp.
  def setup_start_at
    return unless start_at.blank?
    
    self.start_at = Time.now
  end

end  
