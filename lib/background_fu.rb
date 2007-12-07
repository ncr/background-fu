module Background

  def self.jobs
    @@jobs ||= Jobs.new
  end

  class Jobs < Array

    def create(klass, method, *args)
      returning(Job.new(klass, method, *args)) do |job|
        push(job)
      end
    end
    
    undef find
    def find(id)
      detect { |job| job.id == id }
    end
    
  end

  class Job

    def initialize(klass, method, *args)
      @worker = klass.new
      @thread = Thread.new do
        @result = @worker.send!(method, *args)
      end
    end
    
    def id
      object_id
    end
    
    def result
      @result
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
