module Background

  def self.jobs
    @@jobs ||= Jobs.new
  end

  class Jobs < Array

    def create(klass, method, *args)
      job = Job.new(klass, method, *args)
      push(job)
      job
    end
    
    undef find
    def find(id)
      detect { |job| job.id == id }
    end
    
  end

  class Job

    attr_reader :result

    def initialize(klass, method, *args)
      ActiveRecord::Base.verify_active_connections! if defined?(ActiveRecord)
      @worker = klass.new
      @thread = Thread.new do
        @result = @worker.send!(method, *args)
      end
    end
    
    def id
      object_id
    end
    
    def progress
      @worker.instance_variable_get("@progress")
    end
    
    def finished?
      [false, nil].include?(@thread.status)
    end
    
    def destroy
      @thread.kill.status == false
    end

  end  

end
