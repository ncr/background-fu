module Job::Callbacks
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def callbacks
    end
  end
end
