module BackgroundFu
  
  VERSION = "1.0.10"
  CONFIG = YAML::load(File.open("#{RAILS_ROOT}/config/daemons.yml"))['background_fu'] || {}
  CONFIG['cleanup_interval'] ||= :on_startup
  CONFIG['monitor_interval'] ||= 10
  
end
