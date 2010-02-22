require File.join(File.dirname(__FILE__), %w[.. spec_helper])


describe Job do 
  before(:each) do
    @job = Job.enqueue!(ExampleWorker, :add, 1, 2)
    #these specs ignore use of callbacks
    Job.clear_callbacks!
  end
  #TODO DRY this up. Can't get the shoulda macros working
  specify { subject.should validate_presence_of :worker_class }
  specify { subject.should validate_presence_of :worker_method }
  specify { subject.should have_readonly_attribute :worker_class }
  specify { subject.should have_readonly_attribute :worker_method }
  specify { subject.should have_readonly_attribute :args }
  describe "#enqueue!" do
    it "returns an instance of Job containing the given details" do
      @job.should be_instance_of Job
      @job.worker_class.constantize.should == ExampleWorker
      @job.worker_method.to_sym.should == :add
      @job.args.should == [1, 2]
    end
    it "stores a new job" do
      stored = Job.find(@job.id)
      @job.should == stored
    end
  end
  describe "running" do
    context "initialization" do
      it "sets the start time" do
        lambda { 
          @job.initialize_worker
        }.should change{@job.started_at}
        
      end
      it "sets the state to 'running'" do
        lambda {
          @job.initialize_worker
        }.should change{@job.state}.to("running")
      end
      it "instantiates a worker to 'run'" do
        @job.worker_class.constantize.should_receive(:new)
        @job.initialize_worker
      end
    end
    context "invocation" do
      before(:each) do
        ExampleWorker.stub(:new).and_return(mock(ExampleWorker, :add => 1))
        @job.initialize_worker
      end
      it "calls the worker method on the given worker with the given args" do
        worker = @job.instance_variable_get("@worker")
        worker.should_receive(:add).with(1,2)
        @job.invoke_worker_without_threads
      end
      it "stores the result of the worker call" do
        @job.invoke_worker_without_threads
        @job.result.should == @job.worker_class.constantize.new.send(@job.worker_method, *@job.args)
      end
      it "changes the state to 'finished'" do
        @job.invoke_worker_without_threads
        @job.state.should == "finished"
      end
    end
  end
end
