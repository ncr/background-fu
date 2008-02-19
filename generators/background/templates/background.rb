#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

Signal.trap("TERM") { exit }

loop do
  if job = Job.find(:first, :conditions => {:state => "pending"}, :order => "id asc")
    job.get_done!
  else
    sleep 5
  end
end
