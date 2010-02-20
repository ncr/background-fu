require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Job, "Callbacks" do
  subject { Job }
  let(:some_instance) { mock(Job).as_null_object }
  it "has a class method callbacks that returns the callback store" do 
    Job.should respond_to :callbacks
  end
  it "has a hash-like accessible store"
  it "can clear the callbacks store"
end
