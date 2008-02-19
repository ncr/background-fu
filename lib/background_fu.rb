module BackgroundFu
  
  # Invoked optionally from lib/daemons/background.rb 
  def self.enable_bonus_features
    ActiveRecord::Base.allow_concurrency = true
    Job.send!(:include, Job::BonusFeatures)
  end
  
end
