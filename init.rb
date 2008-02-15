Dependencies.load_paths << "#{RAILS_ROOT}/lib/workers"

if ActiveRecord::Base.allow_concurrency
  Job.send!(:include, Job::BonusFeatures)
end
