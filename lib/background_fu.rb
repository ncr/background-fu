module Background

  def self.jobs(options = {})
    options.reverse_merge!(:order => "created_at")
    Job.find(:all, options).extend(Jobs)
  end
  
  module Jobs

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

  end

  class Job < ActiveRecord::Base

    States = %w(pending running finished failed)

    serialize :args,  Array
    serialize :result

    before_validation_on_create :setup_state

    validates_inclusion_of :state, :in => States
    validates_presence_of :worker_class, :worker_method

    States.each do |state_name|
      define_method("#{state_name}?") do
        state == state_name
      end
    end

    def get_done!
      update_attribute(:state, "running")
      @worker     = worker_class.constantize.new
      self.result = @worker.send!(worker_method, *args)
      self.state  = "finished"
    rescue 
      self.state  = "failed"
    ensure
      save(false)
    end

    private

    def setup_state
      return unless state.blank?

      self.state = "pending" 
    end

  end  

end
