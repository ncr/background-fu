require File.dirname(__FILE__) + "/spec_helper"

describe Background::Jobs do

  before do
    @jobs = Background::Jobs.new
  end

  it "should accept new jobs" do
    job = stub(:job)
    Background::Job.should_receive(:new).with(:foo, :bar, :baz).and_return(job)

    @jobs.create(:foo, :bar, :baz).should == job

    @jobs.size.should == 1
  end

  it "should find existing jobs" do
    job = stub(:job, :id => 123)

    @jobs << job

    @jobs.find(123).should == job
  end

end
