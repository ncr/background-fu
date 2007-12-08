require File.dirname(__FILE__) + "/spec_helper"

# Thread stub
class Background::Job::Thread

  def initialize
    yield
  end

end

describe Background::Job do
  
  before do
    @worker       = stub(:worker, :send! => "result")
    @worker_class = stub(:worker_class, :new => @worker)
  end
  
  it "should create correct worker" do
    job = Background::Job.new(@worker_class, :method, "args")

    job.instance_variable_get("@worker").should == @worker
  end
  
  it "should pass correct message to worker" do
    @worker.should_receive(:send!).with(:foo, :bar, :baz)
    
    Background::Job.new(@worker_class, :foo, :bar, :baz)
  end
  
end
