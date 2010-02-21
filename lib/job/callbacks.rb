module Job::Callbacks
  def self.included(base)
    base.alias_method_chain :invoke_worker, :callbacks
    base.extend(ClassMethods)
  end

  def invoke_worker_with_callbacks
    call_before_invokes
    invoke_worker_without_callbacks
  end

  private

    def call_before_invokes
      if has_before_invokes?
        self.class.callbacks[:invoke][:before].each do |method|
          self.send(method)
        end
      end
    end

    def has_before_invokes?
      if invokes = self.class.callbacks[:invoke]
        return invokes.has_key? :before
      end 
    end

  module ClassMethods
    
    def before_invoke(*do_methods)
      do_methods.each do |method|
        set_callback(:invoke, :before, method)
      end
    end

    def callbacks
      @callbacks ||= {}
    end

    def clear_callbacks!
      @callbacks = {}
    end

    private 
      
      #callbacks are stored as a hash 
      #organized by method and when(before, after)
      #each for_method, when pair holds an array
      #of methods to call
      def set_callback(for_method, whn, do_method)
        callbacks[for_method] ||= {}
        callbacks[for_method][whn] ||= []
        callbacks[for_method][whn] << do_method
      end
  end
end
