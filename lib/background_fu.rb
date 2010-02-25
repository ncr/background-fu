module BackgroundFu
  
  VERSION = "1.0.10"
  CONFIG_FILE = "#{RAILS_ROOT}/config/daemons.yml"
  CONFIG = File.exist?(CONFIG_FILE) && YAML::load_file(CONFIG_FILE)['background_fu'] || {}
  CONFIG['cleanup_interval'] ||= :on_startup
  CONFIG['monitor_interval'] ||= 10
  
end

require 'job'
require 'background_fu/worker_monitoring'
require 'background_fu/railtie' if defined?(Rails) && Rails::VERSION == 3


