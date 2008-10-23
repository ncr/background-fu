require File.dirname(__FILE__) + '/test_helper.rb'
require File.dirname(__FILE__) + '/../lib/job.rb'

class JobTest < Test::Unit::TestCase
  
  def setup
    ActiveRecord::Base.allow_concurrency = false
    @job = Job.new
  end
  
  should_have_readonly_attributes :worker_class, :worker_method, :args
  should_require_attributes :worker_class, :worker_method
  
end