#!/usr/bin/env ruby

# You might want to change this
# ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"

# Setting this will enablee progress monitoring. The is optional.
# ActiveRecord::Base.allow_concurrency = true

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
