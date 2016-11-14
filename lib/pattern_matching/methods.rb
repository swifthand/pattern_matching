module PatternMatching
  module Methods

    ##
    # Wraps a matchable 'pattern' in an object that inverts `===` (case-equality method).
    def Match(*pattern)
      ::PatternMatching::CaseEqualityReversal.new(*pattern)
    end

    ##
    # Wraps an argument list as a pattern for use in a call to #Match
    def Pattern(*pattern)
      ::PatternMatching::PatternMatch.new(*pattern)
    end

  end
end
