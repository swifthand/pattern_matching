module PatternMatching
  module ProcHelpers

    ##
    # S for 'send', as in "send message to object".
    # Allows for prettier Proc pattern-matches than simply :sym.to_proc everywhere
    def S(symbol)
      symbol.to_proc
    end

    ##
    # C for 'call', as in "call method in current context".
    # Allows for prettier Method pattern-matches than method(:sym)
    def C(symbol)
      Proc.new { |obj| self.send(symbol, obj) }
    end

  end
end
