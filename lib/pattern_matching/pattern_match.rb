module PatternMatching
  class PatternMatch

    attr_reader   :pattern
    alias_method  :value, :pattern

    def initialize(*pattern)
      @pattern = pattern
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
