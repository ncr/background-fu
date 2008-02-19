# Example:
# 
# job = Job.enqueue!(MyWorker, :my_method, "my_arg_1", "my_arg_2")
class Job < ActiveRecord::Base

  cattr_accessor :states
  self.states = %w(pending running finished failed)

  serialize :args, Array
  serialize :result

  before_create :setup_state
  validates_presence_of :worker_class, :worker_method
  
  attr_readonly :worker_class, :worker_method, :args
  
  def self.enqueue!(worker_class, worker_method, *args)
    create!(
      :worker_class  => worker_class.to_s,
      :worker_method => worker_method.to_s,
      :args          => args
    )
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
  
  def initialize_worker
    update_attributes!(:started_at => Time.now, :state => "running")
    @worker = worker_class.constantize.new
  end
  
  def invoke_worker
    self.result = @worker.send!(worker_method, *args)
    self.state  = "finished"
  end
  
  def rescue_worker(exception)
    self.result = [exception.message, exception.backtrace.join("\n")].join("\n\n")
    self.state  = "failed"
  end
  
  def ensure_worker
    self.progress = @worker.instance_variable_get("@progress")
    save!
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

end  
