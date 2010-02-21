module Job::Callbacks
  def self.included(base)
    base.extend(ClassMethods)
    base.generate_callback_cls_methods
    base.alias_method_chain :invoke_worker, :callbacks
  end

  def invoke_worker_with_callbacks
    call_before_invokes
    invoke_worker_without_callbacks
    call_after_invokes
  end

  private

    def call_before_invokes
      if has_before_invokes?
        self.class.callbacks[:invoke][:before].each do |method|
          self.send(method)
        end
      end
    end

    def call_after_invokes
      if has_after_invokes?
        self.class.callbacks[:invoke][:after].each do |method|
          self.send(method)
        end
      end
    end

    def has_after_invokes?
      if invokes = self.class.callbacks[:invoke]
        return invokes.has_key? :after
      end
    end

    def has_before_invokes?
      if invokes = self.class.callbacks[:invoke]
        return invokes.has_key? :before
      end 
    end

  module ClassMethods

    def generate_callback_cls_methods
      befores   = %w/invoke/
      afters    = %/invoke/ 
      cb_points = {:before => befores, :after => afters}
      
      cb_points.each_pair do |whn, methods| 
        methods.each do |method|
          (class << self; self; end).instance_eval do 
            define_method "#{whn}_#{method}".to_sym  do |*do_methods| 
              do_methods.each do |do_method|
                set_callback(method.to_sym, whn, do_method)
              end
            end
          end
        end
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
