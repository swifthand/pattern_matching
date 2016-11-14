# Allows for crude pattern-matching like behavior. Very crude.
# Currently just a Symbol as a status tag paired with a value.
# Provides capitalized methods (bad form, perhaps?) to make
# them stand out: `#Pattern`, `#Result` and `#Match`.
#
# Example usage:
#
# def some_computation
#   Result(:ok, "awesome sauce")
# end
#
# case (result = some_computation)
# when Match(:ok)
#   puts "Things went okay: #{result.value}"
# when Match(:error)
#   puts "Something went wrong: #{result.value}"
# end
#
# # => "Things went okay: awesome sauce"
#
# Originally named `Result` but that would have a conflicting meaning
# with the typical use of the Result Monad in most languages/environments.
# So while this is not true pattern matching, it might one day grow into
# something of the sort, and so the name fits... in a limited way.
module PatternMatching

  ##
  # Configure behavior based on existing configuration.
  # This is a lot of noodley-looking nested conditional logic but that's
  # kind of the point with lots of boolean-based configuration of behavior!
  def self.included(base)
    if PatternMatching.config.use_binding_helper
      base.const_set(PatternMatching.config.binding_helper, PatternMatching::BindingsSet.new)
      if PatternMatching.config.default_binding_helper?
        base.send(:include, PatternMatching::MethodsWithBindingHelper)
      else
        base.send(:include, PatternMatching.methods_with_custom_binding_helper)
      end
    else
      base.send(:include, PatternMatching::Methods)
    end

    if PatternMatching.config.use_proc_helpers
      if PatternMatching.config.default_proc_helpers?
        base.send(:include, PatternMatching::ProcHelpers)
      else
        base.send(:include, PatternMatching.custom_proc_helpers)
      end
    end
  end

  ##
  # Available configuration options are:
  #
  # - use_proc_helpers: controls whether or not helpers for sending
  #   messages and calling a method in the local context are included
  #   with this module.
  #
  # - use_binding_helper: controls whether or not bindings are enabled (and thus)
  #   whether or not helpers are included.
  #
  # - send_helper: the method name used as the proc helper for
  #   "sending a message" to the object when matching.
  #
  # - call_helper: the method name used as the proc helper for "calling a
  #   method in the current context" with the object as an argument when matching.
  #
  # - binding_helper: the method name used as the binding set for each match.
  def self.configure(&block)
    block.call(config)

    unless config.default_proc_helpers?
      build_custom_proc_helpers(config.send_helper, config.call_helper)
    end

    if config.use_binding_helper && !config.default_binding_helper?
      build_custom_binding_helper(config.binding_helper)
      puts "Using a custom binding helper are we?"
    end
  end

  ##
  # Simple class-instance variable to hold configuration
  def self.config
    @config ||= ::PatternMatching::Configuration.default
  end

  ##
  # For of use in testing, because of how Ruby loading works when testing
  # behavior that is thread-global (?) for the instance of this module.
  def self.default_configuration!
    @config = ::PatternMatching::Configuration.default
  end

  ##
  # Will only be set with a proper module if a call to ::configure results in
  # there being proc helpers with non-default names. Is not intelligently
  # assigned, nor should it be used, when called in any manner before a call
  # to ::configure that specifies an alternative value to config.call_helper
  # and config.binding_helper.
  def self.custom_proc_helpers
    @custom_proc_helpers
  end

  ##
  # Will only be set with a proper module if a call to ::configure results in
  # a binding helper set to a name which is not the default. Is not intelligently
  # assigned, nor should it be used, when called in any manner before a call
  # to ::configure that specifies an alternative value to config.binding_helper
  def self.methods_with_custom_binding_helper
    @methods_with_custom_binding_helper
  end

  ##
  # Implementations internal to the blocks of the define_method calls
  # should remain identical to the implementations in the PatternMatching::ProcHelpers
  # module, with the only change being that the produced module has different names for
  # the methods behind the call and send helpers.
  def self.build_custom_proc_helpers(send_helper, call_helper)
    proc_helpers = ->() {
      define_method(send_helper) do |symbol|
        symbol.to_proc
      end

      define_method(call_helper) do |symbol|
        Proc.new { |obj| self.send(symbol, obj) }
      end
    }

    @custom_proc_helpers = Module.new
    @custom_proc_helpers.class_exec(&proc_helpers)
  end

  ##
  # The implementation of the METHODS heredoc should remain identical to the contents of
  # the Match and Pattern methods of PatternMatching::MethodsWithBindingHelper except that
  # here we are interpolating on our
  def self.build_custom_binding_helper(binding_helper)
    methods_with_binding = ->() {
      eval(
<<-METHODS
def Match(*pattern)
  result = ::PatternMatching::CaseEqualityReversal.new(*pattern)
  (self.class)::#{binding_helper}._clear_bindings!(caller_locations(1,1)[0].label) unless result
  result
end

def Pattern(*pattern)
  (self.class)::#{binding_helper}._clear_bindings!(caller_locations(1,1)[0].label)
  ::PatternMatching::PatternMatch.new(*pattern)
end
METHODS
      )
    }
    @methods_with_custom_binding_helper = Module.new
    @methods_with_custom_binding_helper.class_exec(&methods_with_binding)
  end

  ##
  # Additional singleton constants and wildcards
  Undefined = Object.new
  Any       = Object.new
  Head      = Object.new
  Tail      = Object.new
  def Undefined.inspect ; "<Undefined>" ; end
  def Undefined.to_s    ; "<Undefined>" ; end
  def Any.inspect       ; "<Any>"       ; end
  def Any.to_s          ; "<Any>"       ; end
  def Head.inspect      ; "<Head>"      ; end
  def Head.to_s         ; "<Head>"      ; end
  def Tail.inspect      ; "<Tail>"      ; end
  def Tail.to_s         ; "<Tail>"      ; end

end


##
# Include the rest of this library.
Dir[File.join(File.dirname(__FILE__), "pattern_matching", "*.rb")].each do |rb_file|
  require rb_file
end
