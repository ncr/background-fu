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
  let(:worker_instance) {mock(ExampleWorker, :add => 3)}
  before(:each) do
    ExampleWorker.stub(:new).and_return(worker_instance)
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
  describe "before_rescue" do 
    let(:callback_point) { :before_rescue }
    before(:each) do 
      some_instance.stub(:invoke_worker).and_raise(Exception)
    end
    it_should_behave_like "Any CB Point"
  end
  describe "after_rescue" do
    let(:callback_point) { :after_rescue }
    before(:each) do
      some_instance.stub(:invoke_worker).and_raise(Exception)
    end
    it_should_behave_like "Any CB Point"
  end
  describe "before_ensure" do
    let(:callback_point) { :before_ensure }
    it_should_behave_like "Any CB Point"
  end
  describe "after_ensure" do
    let(:callback_point) { :after_ensure }
    it_should_behave_like "Any CB Point"
  end
  describe "magic hooks (worker hooks)" do
    before(:each) do
      some_instance.initialize_worker
      worker_instance.stub(:before_add)
    end
    context "before and after" do
      it "calls before_worker_method_name if defined before worker_method" do
        worker_instance.should_receive(:before_add).ordered
        worker_instance.should_receive(:add).ordered
        some_instance.invoke_worker
      end
      it "calls after_worker_method_name if defined after worker_method" do
        worker_instance.should_receive(:add).ordered
        worker_instance.should_receive(:after_add).ordered
        some_instance.invoke_worker
      end
    end
  end
end
