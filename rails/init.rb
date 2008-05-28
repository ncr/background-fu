require 'background_fu'
require 'background_fu/worker_monitoring'
require 'job'

Dependencies.load_paths << "#{RAILS_ROOT}/lib/workers"

if ActiveRecord::Base.allow_concurrency
  require 'job/bonus_features'
  Job.send!(:include, Job::BonusFeatures)
end
