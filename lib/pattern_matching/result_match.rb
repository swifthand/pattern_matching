# Allows for crude pattern-matching like behavior. Very crude.
# Currently just a Symbol as a status tag paired with a value.
# Provides two capitalized methods (bad form, perhaps?) to make
# them stand out: `#Pattern` and `#Match`.
#
# Example usage:
#
# def some_computation
#   Pattern(:ok, "awesome sauce")
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
  class ResultMatch
    attr_reader :status, :value, :pattern

    def initialize(status, value = Undefined)
      @status   = status
      @value    = value
      @pattern  = Undefined == value ? [status] : [status, value]
    end


    def ===(*other)
      match_enumerable(pattern, other)
    end


  private ######################################################################


    def match_enumerable(from_self, from_other)
      return false if from_self.length < from_other.length
      combined = from_self.zip(from_other)
      combined.reduce(true) do |acc, (self_item, other_item)|
        acc && match_item(self_item, other_item)
      end
    end


    def match_item(from_self, from_other)
      if Any == from_other
        true
      elsif Enumerable === from_other && Enumerable === from_self
        match_enumerable(from_self, from_other)
      else
        from_other === from_self
      end
    end

  end
end
