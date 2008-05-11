class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string  :worker_class
      t.string  :worker_method
      
      t.text    :args
      t.integer :priority

      t.integer :progress
      t.string  :state
      
      t.integer :lock_version, :default => 0
      
      t.timestamp :start_at
      t.timestamp :started_at
      t.timestamps
      
      t.columns << 'result longtext' # text can store 65kb only, it's often too short
    end

    add_index :jobs, :state
    add_index :jobs, :start_at
    add_index :jobs, :priority
  end

  def self.down
    drop_table :jobs
  end
end
