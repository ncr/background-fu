class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string  :worker_class
      t.string  :worker_method

      t.text    :args
      t.text    :result

      t.integer :progress
      t.string  :state
      
      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
