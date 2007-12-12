class BackgroundGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "create_jobs"
      end

      m.directory "lib/daemons"
      m.file 'background_daemon.rb', 'lib/daemons/background.rb', :collision => :force # overwrite daemon stub

      m.directory "lib/workers"
      m.file 'example_worker.rb', 'lib/workers/example_worker.rb'
    end
  end

  protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration", "Don't generate a migration file for Job model") { |v| options[:skip_migration] = v }
  end

end
