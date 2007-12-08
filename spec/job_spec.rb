require File.dirname(__FILE__) + "/spec_helper"

describe Background::Job do
  
  before do
    @worker       = stub(:worker, :send! => "result")
    @worker_class = stub(:worker_class, :new => @worker)
  end
  
  it "should create correct worker" do
    job = Background::Job.new(@worker_class, :method, "args")

    job.worker.should == @worker
  end
  
  it "should pass correct message to worker" do
    @worker.should_receive(:send!).with(:foo, :bar, :baz)
    
    Background::Job.new(@worker_class, :foo, :bar, :baz)
  end
  
end
