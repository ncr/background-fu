#!/usr/bin/env ruby

# You might want to change this
# ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true;
Signal.trap("TERM") do 
  $running = false
end

while($running) do

  if job = Background::Job.find(:first, :conditions => { :state => "pending" }, :order => "created_at")
    begin
      job.state  = "running"; job.save(false)
      worker     = job.worker_class.camelize.constantize.new
      job.result = worker.send!(job.worker_method, *job.args)
      job.state  = "finished"
    rescue 
      job.state = "failed"
    ensure
      job.save(false)
    end
  else
    sleep 5
  end

end
