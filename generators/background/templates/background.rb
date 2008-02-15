#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

# Setting this will enable worker monitoring. The is optional.
#ActiveRecord::Base.allow_concurrency = true

$running = true;
Signal.trap("TERM") do 
  $running = false
  
  # We are exiting explicitly.
  # This is convenient if you set much longer sleeps below.
  # If sleep is long, you would have to wait long for next iteration
  # of "while" (which would result in daemon death).
  exit
end

while($running) do

  if job = Job.pending.first
    job.get_done!
  else
    sleep 5
  end

end
