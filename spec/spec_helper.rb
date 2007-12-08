$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + "/../init"

# Thread stub
class Background::Job::Thread

  def initialize
    yield
  end

end
