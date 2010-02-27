#!/usr/bin/env ruby
require "rubygems"
require "rails"
require "active_record"
require "background_fu"

require File.dirname(__FILE__) + "/../config/boot"
require File.dirname(__FILE__) + "/../config/environment"

Signal.trap("TERM") { exit }

puts "BackgroundFu: Starting up."
#RAILS_DEFAULT_LOGGER.info("BackgroundFu: Starting daemon (bonus features #{Job.included_modules.include?(Job::BonusFeatures) ? "enabled" : "disabled"}).")

puts "With Config:"
BackgroundFu::CONFIG.each do |k,v| 
  puts "\t#{k}: #{v.to_s}"
#  RAILS_DEFAULT_LOGGER.info "BackgroundFu: #{k}: #{v.to_s}"
end

if BackgroundFu::CONFIG['cleanup_interval'] == :on_startup
  puts "Cleaning finished jobs...(on startup)"
  Job.cleanup_finished_jobs 
end

loop do
  if job = Job.find(:first, :conditions => ["state='pending' and start_at <= ?", Time.zone.now.to_s(:db)], :order => "priority desc, start_at asc")
    puts "Found job: #{job.id}. Going to do what you asked with it now."
    job.get_done!
  else
    puts "Waiting for jobs..."
    #RAILS_DEFAULT_LOGGER.info("BackgroundFu: Waiting for jobs...")
    sleep BackgroundFu::CONFIG['monitor_interval']
  end
  Job.cleanup_finished_jobs if BackgroundFu::CONFIG['cleanup_interval'] == :continuous
end
