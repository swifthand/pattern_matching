require 'test_helper'

PatternMatching.configure do |config|
  config.use_proc_helpers = true
  config.send_helper      = :foo
  config.call_helper      = :bar
end

module ConfigurationTests
  class RenamedProcHelpers < Minitest::Test
    include PatternMatching

    test "send helper is defined as foo" do
      assert_respond_to(self, :foo)
    end

    test "call helper is defined as bar" do
      assert_respond_to(self, :bar)
    end


    test "can use S as a shortcut for symbol-to-proc" do
      result = Pattern(42, "", 555)
      assert_match(result,  foo(:even?),  foo(:empty?), foo(:odd?))
      refute_match(result,  foo(:odd?),   foo(:empty?), foo(:odd?))
    end


    def contains_e?(str)
      str.kind_of?(String) && str.count('e') > 0
    end


    def forty_two?(val)
      42 == val
    end


    def triple_five?(val)
      555 == val
    end


    test "can use C as a shortcut for methods in current context" do
      result = Pattern(42, "streetlight", 555)
      assert_match(result,  bar(:forty_two?),  bar(:contains_e?), bar(:triple_five?))
      refute_match(result,  bar(:forty_two?),  bar(:forty_two?),  bar(:triple_five?))
    end

  end
end

