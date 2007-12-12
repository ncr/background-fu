require File.dirname(__FILE__) + "/spec_helper"

describe Background::Job do
  
  it "should create correct worker" do
    Background::Job.should_receive(:create).with(:worker_class => "worker_class", :worker_method => "worker_method", :args => ["arg1", "arg2"])

    job = Background.jobs.create("worker_class", "worker_method", "arg1", "arg2")
  end
  
end
