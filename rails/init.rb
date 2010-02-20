require 'background_fu'
require 'background_fu/worker_monitoring'
require 'job'
require 'job/bonus_features'

ActiveSupport::Dependencies.load_paths << "#{RAILS_ROOT}/lib/workers"

# comment out these lines if to disable callbacks
require 'job/callbacks'
Job.send(:include, Job::Callbacks)

#ref    http://guides.rubyonrails.org/2_2_release_notes.html says 2.2 onwards allow_concurrency deprecated
if (Rails::VERSION::STRING >= '2.2') or (ActiveRecord::Base.method_defined?(:allow_concurrency) and ActiveRecord::Base.allow_concurrency)
  Job.send(:include, Job::BonusFeatures)
end
