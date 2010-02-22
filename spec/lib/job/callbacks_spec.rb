require File.join(File.dirname(__FILE__), %w[.. .. spec_helper])

#in case people want to run specs
#before script/generate background
class ExampleWorker; end

describe Job, "Callbacks" do
  subject { Job }
  let(:some_instance) do
    unless job = Job.find(:first)
      job = Job.enqueue!(ExampleWorker, :add, 1, 2)
    end
    3.times do |i|
      job.stub!("method#{i+1}").and_return(nil)
    end
    job
  end
  before(:each) do
    ExampleWorker.stub(:new).and_return(mock(ExampleWorker, :add => 3))
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
  describe "after_init" do
    let(:callback_point) { :after_init }
    it_should_behave_like "Any CB Point"
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
