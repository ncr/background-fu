require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

describe Job, "Callbacks" do
  subject { Job }
  let(:example_worker) { mock("Some Worker", :some_method => "a result") }
  let(:some_instance) do
    unless job = Job.find(:first)
      job = Job.enqueue!(example_worker, :some_method)
    end
    3.times do |i|
      job.stub!("method#{i+1}").and_return(nil)
    end
    job.instance_variable_set("@worker", example_worker)
    job
  end
  it "has a class method callbacks that returns the callback store" do 
    subject.should respond_to :callbacks
  end
  it "has a hash-like accessible store" do 
    subject.callbacks.should respond_to :[]
  end
  it "can clear the callbacks store" do
    subject.clear_callbacks!
    subject.callbacks.should == {}
  end
  describe "before_invoke" do       
    let (:callback_point) { :before_invoke }
    it_should_behave_like "Any CB Point"
  end
  describe "after_invoke" do
    let (:callback_point) { :after_invoke }
    it_should_behave_like "Any CB Point"
  end
end
