require 'rails/generators'
require 'rails/generators/migration'

class BackgroundGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  class_option :skip_migration, :type => :boolean, :desc => "Do not copy migration files"
  class_option :skip_examples, :type => :boolean, :desc => "Do not copy examples files"

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

   # Implement the required interface for Rails::Generators::Migration.
   # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
  def self.next_migration_number(dirname) #:nodoc:
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def copy_daemons
    template 'background.rb', 'script/background'
  end

  def copy_examples
    unless options[:skip_examples]
      template 'example_worker.rb', 'lib/workers/example_worker.rb'
      template 'example_monitored_worker.rb', 'lib/workers/example_monitored_worker.rb'
    end
  end

  def create_migration_file
    migration_template 'migration.rb', 'db/migrate/create_jobs.rb' unless options[:skip_migration]  
  end

end
