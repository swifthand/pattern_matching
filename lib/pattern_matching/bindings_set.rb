module PatternMatching
  class BindingsSet

    ##
    # For reasons I have yet to determine, implementing BindingsSet as a subclass
    # of BasicObject has caused stack overflow issues. So the current workaround
    # is to just remove everything we possibly can from this class at load time
    # via the very hamfisted Module#undef_method.
    REMOVABLE_OBJECT_METHODS = [
      :nil?,
      :===,
      :=~,
      :!~,
      :eql?,
      :hash,
      :<=>,
      :class,
      :singleton_class,
      :clone,
      :dup,
      :taint,
      :tainted?,
      :untaint,
      :untrust,
      :untrusted?,
      :trust,
      :freeze,
      :frozen?,
      :to_s,
      :inspect,
      :methods,
      :singleton_methods,
      :protected_methods,
      :private_methods,
      :public_methods,
      :instance_variables,
      :instance_variable_get,
      :instance_variable_set,
      :instance_variable_defined?,
      :remove_instance_variable,
      :instance_of?,
      :kind_of?,
      :is_a?,
      :tap,
      :send,
      :public_send,
      :respond_to?,
      :extend,
      :display,
      :method,
      :public_method,
      :singleton_method,
      :define_singleton_method,
      :to_enum,
      :enum_for,
    ]

    REMOVABLE_OBJECT_METHODS.each do |msg|
      undef_method(msg)
    end


    def initialize
      @bindings = {}
    end

    ###
    # Based on the caller's method name (obviously not an universally-optimal choice),
    # cache a Bindings object and forward all messages there.
    def method_missing(msg, *)
      caller_label = caller_locations(1,1)[0].label
      @bindings[caller_label] ||= PatternMatching::Bindings.new
      @bindings[caller_label].send(msg)
    end

    ##
    # Used internally as a hacky hook into auto-bindings with the B constant,
    # when enabled. See documentation for automatic bindings.
    def _clear_bindings!(caller_label)
      @bindings.delete(caller_label)
    end

  end
end
