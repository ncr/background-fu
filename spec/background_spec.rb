require File.dirname(__FILE__) + "/spec_helper"

describe Background do
  
  it "should have jobs extended with Background::Jobs" do
    jobs = stub(:jobs)
    jobs.should_receive(:extend).with(Background::Jobs)
    Background::Job.should_receive(:find).and_return(jobs)

    Background.jobs
  end

end
