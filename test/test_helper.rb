# supress warnings
$VERBOSE = false

require 'rubygems'
require 'mocha'
require 'active_record'
require 'test/unit'

# gem install thoughtbot-shoulda --source http://gems.github.com
require 'shoulda'
require 'shoulda/active_record'

ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), 'test.log'))
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile  => ':memory:')

ActiveRecord::Schema.define do
  create_table :jobs do |t|
    t.string  :worker_class
    t.string  :worker_method
    
    t.text    :args
    t.text    :result

    t.integer :priority

    t.integer :progress
    t.string  :state
    
    t.integer :lock_version, :default => 0
    
    t.timestamp :start_at
    t.timestamp :started_at
    t.timestamps
  end

  add_index :jobs, :state
  add_index :jobs, :start_at
  add_index :jobs, :priority
end
