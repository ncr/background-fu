#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

$running = true;
Signal.trap("TERM") do 
  $running = false
end

while($running) do

  if job = Background.jobs.find_in_state("pending")
    job.get_done!
  else
    sleep 5
  end

end
