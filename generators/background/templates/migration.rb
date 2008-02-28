class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string  :worker_class
      t.string  :worker_method

      t.text    :args

      t.integer :progress
      t.string  :state
      
      t.timestamp :started_at
      t.timestamps
      
      t.columns << 'result longtext' # text can store 65kb only, it's often too short
    end
    add_index :jobs, :state
  end

  def self.down
    drop_table :jobs
  end
end
