require 'background_fu'
require 'background_fu/worker_monitoring'
require 'job'
require 'job/bonus_features'

Dependencies.load_paths << "#{RAILS_ROOT}/lib/workers"

if ActiveRecord::Base.allow_concurrency
  Job.send!(:include, Job::BonusFeatures)
end
