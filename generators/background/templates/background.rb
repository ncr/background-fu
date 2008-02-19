#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

# Progress monitoring, stopping/restarting jobs.
# Comment this out if you don't need these features.
BackgroundFu.enable_bonus_features

Signal.trap("TERM") { exit }

loop do
  if job = Job.find(:first, :conditions => {:state => "pending"}, :order => "id asc")
    job.get_done!
  else
    sleep 5
  end
end
