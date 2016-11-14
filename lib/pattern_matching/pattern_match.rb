module PatternMatching
  ##
  # Encapsulates pattern matching behaviors such as deep-matching of collection
  # types as well as wildcard values such as `Any`.
  class PatternMatch

    attr_reader   :pattern
    alias_method  :value, :pattern

    def initialize(*pattern)
      @pattern = pattern
    end

    ##
    # As both self.pattern and other are slurped, they are guaranteed to begin as
    # Arrays (i.e. they are enumerable). Thus all matches begin by checking a match
    # as if the values are enumerable.
    def ===(*other)
      match_enumerable(pattern, other)
    end


  private ######################################################################

    ##
    # Enumerable arguments with different lengths are not equal, at least as long as
    # wildcards such as Head and Tail remain un-implemented. This is used as a
    # fast-reject clause. Otherwise, iteration is used to decide
    #
    # TODO: There might be a better way of determining which objects are legitimately
    #       useful as matachable collections than simply descending from Enumerable or
    #       responding to #length, #zip and #reduce, as is implicit here.
    def match_enumerable(from_self, from_other)
      return false if from_self.length < from_other.length
      combined = from_self.zip(from_other)
      combined.reduce(true) do |acc, (self_item, other_item)|
        acc && match_item(self_item, other_item)
      end
    end

    ##
    # Handles matching for non-collection values, including the logic behind
    # the wildcard Any. In the case of a collection, defers instead to #match_enumerable.
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
