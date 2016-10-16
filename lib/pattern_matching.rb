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

  # Allows for prettier Proc pattern-matches than simply :sym.to_proc everywhere
  def P(symbol)
    symbol.to_proc
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
