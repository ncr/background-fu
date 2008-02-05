#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

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

  if job = Background.jobs.find_in_state("pending")
    job.get_done!
  else
    sleep 5
  end

end
