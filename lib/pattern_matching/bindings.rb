module PatternMatching
  ##
  # Taken nearly verbatim from the idea presented by Avdi Grimm in an episode of
  # the fantastic Ruby Tapas series, including the use of the >> (right-shift) operator
  # as a "guard" operator, as visually stands out compared to other define-able
  # binary operators but it lacks idiomatic re-use the way that << (left-shift) does.
  # It also feels a little bit like the \\ guards used in Elixir, which I would have
  # used, if I could find a way to have Ruby treat either \\ or // as a binary operator.
  class Bindings < BasicObject

    def initialize
      @bindings = ::Hash.new do |hash, key|
        ::PatternMatching::Bindings::BoundValue.new(hash, key)
      end
    end

    ##
    # Hello darkness, my old friend.
    def method_missing(msg, *)
      @bindings[msg]
    end


    ##
    # The interesting work of Bindings happens in this class.
    #
    # Allows setting up guards via the >> oprator.
    #
    # If guards pass, or no guards have been added to a BoundValue,
    # then comparing via == or === with that BoundValue will always
    # return true, and will save the compared-to value in the hash,
    # presumably provided by an instance of the Bindings class.
    class BoundValue
      def initialize(bindings, name)
        @bindings = bindings
        @name     = name
        @guards   = []
      end

      def ==(other)
        return false unless @guards.all? { |g| g === other }
        @bindings[@name] = other
        true
      end

      def ===(other)
        return false unless @guards.all? { |g| g === other }
        @bindings[@name] = other
        true
      end

      def >>(guard)
        @guards << guard
        self
      end
    end

  end
end
