module PatternMatching
  ##
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
