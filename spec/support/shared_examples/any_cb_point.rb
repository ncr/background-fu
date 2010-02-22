shared_examples_for "Any CB Point" do
  before(:each) do
    subject.clear_callbacks!
  end
  it "takes a symbol representing a method to call" do
    subject.send(callback_point, :method1)
  end
  it "takes a list of symbols representing methods to call" do
    subject.send(callback_point, :method1, :method2)
  end
  describe "callback" do
    let(:cb_methods) { [:method1, :method2, :method3] }
    before(:each) do
      subject.send(callback_point, *cb_methods)
    end
    it "calls each method in order" do
      cb_methods.each do |method|
        some_instance.should_receive(method).ordered
      end
      some_instance.initialize_worker
      some_instance.invoke_worker
    end      
  end
end
