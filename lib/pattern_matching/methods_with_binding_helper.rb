module PatternMatching
  module MethodsWithBindingHelper

    ##
    # Wraps a matchable 'pattern' in an object that inverts `===` (case-equality method).
    def Match(*pattern)
      result = ::PatternMatching::CaseEqualityReversal.new(*pattern)
      (self.class)::B._clear_bindings!(caller_locations(1,1)[0].label) unless result
      result
    end

    ##
    # Wraps an argument list as a pattern for use in a call to #Match
    def Pattern(*pattern)
      (self.class)::B._clear_bindings!(caller_locations(1,1)[0].label)
      ::PatternMatching::PatternMatch.new(*pattern)
    end

  end
end

