module Job::Callbacks
  def self.included(base)
    befores   = %w/invoke/
    afters    = %w/init invoke/ 
    cb_points = {:before => befores, :after => afters}
      
    base.extend(ClassMethods)
    base.setup_callbacks_for cb_points
    base.alias_method_chain :initialize_worker, :callbacks
    base.alias_method_chain :invoke_worker, :callbacks
  end

  def initialize_worker_with_callbacks
    initialize_worker_without_callbacks
    call_after_inits
  end

  def invoke_worker_with_callbacks
    call_before_invokes
    invoke_worker_without_callbacks
    call_after_invokes
  end

  module ClassMethods
    
    def setup_callbacks_for(callback_points)
      callback_points.each_pair do |whn, methods| 
        methods.each do |method|
          generate_callback_cls_method(whn, method)
          generate_callback_checker(whn, method)
          generate_callback_caller(whn, method)
        end
      end
    end

    def generate_callback_cls_method(whn, method)
      (class << self; self; end).instance_eval do 
        define_method "#{whn}_#{method}".to_sym  do |*do_methods| 
          do_methods.each do |do_method|
            set_callback(method.to_sym, whn, do_method)
          end
        end
      end
    end

    def generate_callback_checker(whn, method)
      define_method callback_checker_name(whn, method) do
        if for_method = self.class.callbacks[method.to_sym]
          return for_method.has_key?(whn)
        end
      end
    end

    def generate_callback_caller(whn, method)
      define_method "call_#{whn}_#{method}s" do
        if send(self.class.callback_checker_name(whn, method))
          self.class.callbacks[method.to_sym][whn].each do |do_method|
            send(do_method)
          end
        end
      end
    end

    def callback_checker_name(whn, method)
      "has_#{whn}_#{method}s?".to_sym
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
