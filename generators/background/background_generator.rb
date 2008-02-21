class BackgroundGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "create_jobs"
      end

      m.directory "lib/daemons"
      m.file 'background.rb', 'lib/daemons/background.rb'
      m.file 'background_ctl', 'lib/daemons/background_ctl'

      m.directory "lib/workers"
      m.file 'example_worker.rb', 'lib/workers/example_worker.rb'
      m.file 'example_monitored_worker.rb', 'lib/workers/example_monitored_worker.rb'
      
      m.file 'daemons.yml', 'config/daemons.yml'
      m.file 'daemons', 'script/daemons'
      
      if options[:scaffold]
        m.directory "app/views/jobs"
        m.file 'scaffold/jobs_controller.rb', 'app/controllers/jobs_controller.rb'
        m.file 'scaffold/jobs_helper.rb', 'app/helpers/jobs_helper.rb'
        m.file 'scaffold/index.html.erb', 'app/views/jobs/index.html.erb'
        m.file 'scaffold/_job.html.erb', 'app/views/jobs/_job.html.erb'
        m.file 'scaffold/_job_deleted.html.erb', 'app/views/jobs/_job_deleted.html.erb'
        m.file 'scaffold/_progress_indicator.html.erb', 'app/views/jobs/_progress_indicator.html.erb'
        m.file 'scaffold/jobs.html.erb', 'app/views/layouts/jobs.html.erb'
        m.file 'scaffold/background_fu.css', 'public/stylesheets/background_fu.css'
        m.route_resources :jobs
      end
    end
  end

  protected

  def add_options!(opt)
    opt.on("--skip-migration", "Don't generate a migration file for Job model") { |v| options[:skip_migration] = v }
    opt.on("--scaffold", "Generate scaffold controller and views for Job model") { |v| options[:scaffold] = v }
  end

end
