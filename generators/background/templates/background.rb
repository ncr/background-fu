#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"

Signal.trap("TERM") { exit }

if Job.included_modules.include?(Job::BonusFeatures)
  RAILS_DEFAULT_LOGGER.info("BackgroundFu: Starting daemon (bonus features enabled).")
else
  RAILS_DEFAULT_LOGGER.info("BackgroundFu: Starting daemon (bonus features disabled).")
end

loop do
  if job = Job.find(:first, :conditions => ["state='pending' and start_at <= ?", Time.now.utc], :order => "priority desc, start_at asc")
    job.get_done!
  else
    RAILS_DEFAULT_LOGGER.info("BackgroundFu: Waiting for jobs...")
    sleep 5
  end
  
  Job.destroy_all(["state='finished' and updated_at < ?", 1.week.ago])
end
