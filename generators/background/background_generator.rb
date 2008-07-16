class BackgroundGenerator < Rails::Generator::Base

  default_options :skip_migration => false, :skip_scaffold => false, :skip_examples => false

  def manifest
    record do |m|
      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "create_jobs"
      end

      m.directory "lib/daemons"
      m.file 'background.rb',  'lib/daemons/background.rb'
      m.file 'background_ctl', 'lib/daemons/background_ctl'

      m.directory "lib/workers"
      
      unless options[:skip_examples]
        m.file 'example_worker.rb',           'lib/workers/example_worker.rb'
        m.file 'example_monitored_worker.rb', 'lib/workers/example_monitored_worker.rb'
      end
      
      m.file 'daemons.yml', 'config/daemons.yml'
      m.file 'daemons',     'script/daemons'
      
      unless options[:skip_scaffold]
        m.directory 'app/controllers/admin'
        m.directory 'app/helpers/admin'
        m.directory 'app/views/admin/jobs'
        m.directory 'app/views/layouts/admin'

        m.file 'scaffold/application_controller.rb', 'app/controllers/admin/application_controller.rb'
        m.file 'scaffold/jobs_controller.rb',        'app/controllers/admin/jobs_controller.rb'
        m.file 'scaffold/jobs_helper.rb',            'app/helpers/admin/jobs_helper.rb'

        m.file 'scaffold/index.html.erb',               'app/views/admin/jobs/index.html.erb'
        m.file 'scaffold/new.html.erb',                 'app/views/admin/jobs/new.html.erb'
        m.file 'scaffold/_form.html.erb',               'app/views/admin/jobs/_form.html.erb'
        m.file 'scaffold/_job.html.erb',                'app/views/admin/jobs/_job.html.erb'
        m.file 'scaffold/_job_deleted.html.erb',        'app/views/admin/jobs/_job_deleted.html.erb'
        m.file 'scaffold/_progress_indicator.html.erb', 'app/views/admin/jobs/_progress_indicator.html.erb'

        m.file 'scaffold/jobs.html.erb', 'app/views/layouts/admin/jobs.html.erb'

        m.file "scaffold/background_fu.css", "public/stylesheets/background_fu.css"
        
        
      end
    end
  end

  protected

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--skip-migration", "Don't generate migration file for this model")                { |v| options[:skip_migration] = v }
    opt.on("--skip-scaffold",  "Don't generate scaffold controller and views for this model") { |v| options[:skip_scaffold]  = v }
    opt.on("--skip-examples",  "Don't generate example workers")                              { |v| options[:skip_examples]  = v }
  end

end
