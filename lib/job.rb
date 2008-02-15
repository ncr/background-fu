# Example:
# 
# job = Job.enqueue!(MyWorker, :my_method, "my_arg_1", "my_arg_2")
class Job < ActiveRecord::Base

  States = %w(pending running stopping finished failed)

  serialize :args, Array
  serialize :result

  before_validation_on_create :setup_state

  validates_inclusion_of :state, :in => States
  validates_presence_of :worker_class, :worker_method

  def self.enqueue!(worker_class, worker_method, *args)
    create!(
      :worker_class  => worker_class.to_s,
      :worker_method => worker_method.to_s,
      :args          => args
    )
  end

  States.each do |state_name|
    # Every call to these methods fetches fresh state value from db.
    define_method("#{state_name}?") do
      reload.state == state_name
    end
    
    # BackgroundJob.running => array of running jobs, etc.
    self.class.send!(:define_method, state_name) do
      find_all_by_state(state_name, :order => "id desc")
    end
  end

  # Invoked by a background daemon.
  def get_done!
    update_attribute(:state, "running")
    @worker = worker_class.constantize.new
    before_work
    catch(:stopped) do
      self.result = @worker.send!(worker_method, *args)
    end
    self.state = "finished"
  rescue Exception => e
    self.result = [e.message, e.backtrace.join("\n")].join("\n")
    self.state = "failed"
  ensure
    save(false)
    after_work
  end

  def setup_state
    return unless state.blank?

    self.state = "pending" 
  end
  
  # callbacks
  def before_work; end
  def after_work; end

end  
