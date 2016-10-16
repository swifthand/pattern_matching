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


  def self.included(base)
    if PatternMatching.config.use_proc_helpers
      if PatternMatching.default_proc_helpers?
        base.send(:include, PatternMatching::ProcHelpers)
      else
        base.send(:include, PatternMatching.custom_proc_helpers)
      end
    end
  end


  Config = Struct.new(
    :use_proc_helpers,
    :use_bindings,
    :send_helper,
    :call_helper,
    :binding_helper
  )


  def self.config
    @config ||= Config.new(true, true, :S, :C, :B)
  end


  def self.default_configuration!
    @config = Config.new(true, true, :S, :C, :B)
  end


  def self.configure(&block)
    block.call(config)
    build_custom_proc_helpers   unless default_proc_helpers?
    # build_custom_binding_helper unless default_binding_helper?
  end


  def self.build_custom_proc_helpers
    current_config = self.config
    proc_helpers = ->() {
      define_method(current_config.send_helper) do |symbol|
        symbol.to_proc
      end

      define_method(current_config.call_helper) do |symbol|
        Proc.new { |obj| self.send(symbol, obj) }
      end
    }

    @custom_proc_helpers = Module.new
    @custom_proc_helpers.class_exec(&proc_helpers)
  end


  def self.custom_proc_helpers
    @custom_proc_helpers
  end


  def self.default_proc_helpers?
    :S == config.send_helper && :C == config.call_helper
  end


################################################################################


  Undefined = Object.new
  Any       = Object.new
  def Undefined.inspect ; "<Undefined>" ; end
  def Undefined.to_s    ; "<Undefined>" ; end
  def Any.inspect       ; "<Any>"       ; end
  def Any.to_s          ; "<Any>"       ; end

  # Wraps a 'pattern' in an object that inverts `===` (case-equality method).
  def Match(*pattern)
    ::PatternMatching::CaseEqualityReversal.new(*pattern)
  end

  # TODO: More robust implementation that recruses into data structures and the like.
  def Pattern(*pattern)
    ::PatternMatching::PatternMatch.new(*pattern)
  end


  # Used by #Match to invert the call to `===` by `when` clauses
  class CaseEqualityReversal < BasicObject
    def initialize(*pattern)
      @pattern = pattern
    end

    def ===(other)
      other.===(*@pattern)
    end
  end

end


Dir[File.join(File.dirname(__FILE__), "pattern_matching", "*.rb")].each do |rb_file|
  require rb_file
end
