module BackgroundFu
  class Railtie < Rails::Railtie
    railtie_name :background_fu

    initializer "background_fu.set_load_paths", :after => :set_load_path do |app|
      app.config.load_paths += %w('lib/workers')
    end
  end
end
