require File.dirname(__FILE__) + "/spec_helper"

describe Background do
  
  it "should have jobs" do
    Background.jobs.should be_an_instance_of(Background::Jobs)
  end
  
  it "should initalize jobs once" do
    Background.jobs.should == Background.jobs
  end

end
