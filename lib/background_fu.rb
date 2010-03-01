module BackgroundFu
  
  VERSION = "1.0.10"
  CONFIG_FILE = "config/background.yml"
  CONFIG = File.exist?(CONFIG_FILE) && YAML::load_file(CONFIG_FILE)['background_fu'] || {}
  CONFIG['cleanup_interval'] ||= :on_startup
  CONFIG['monitor_interval'] ||= 10
  
end

require 'background_fu/job'
require 'background_fu/job/bonus_features'
require 'background_fu/worker_monitoring'
require 'background_fu/railtie' if defined?(Rails) && Rails::VERSION::MAJOR == 3

Job.send(:include, Job::BonusFeatures)

Dir["lib/workers/*_worker.rb"].each { |f| require f } 

