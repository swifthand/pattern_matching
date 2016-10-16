require 'test_helper'

PatternMatching.default_configuration!

class ProcHelperTest < Minitest::Test
  include PatternMatching


  test "can use S as a shortcut for symbol-to-proc" do
    result = Pattern(42, "", 555)

    assert_match(result,  S(:even?),  S(:empty?), S(:odd?))

    refute_match(result,  S(:odd?),   S(:empty?), S(:odd?))
    refute_match(result,  S(:even?),  S(:empty?), S(:even?))
    refute_match(result,  S(:even?),  S(:nil?),   S(:odd?))
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

    assert_match(result,  C(:forty_two?),  C(:contains_e?), C(:triple_five?))

    refute_match(result,  C(:forty_two?),  C(:forty_two?),  C(:triple_five?))
    refute_match(result,  C(:forty_two?),  C(:contains_e?), C(:contains_e?))
    refute_match(result,  C(:forty_two?),  C(:contains_e?), C(:forty_two?))
  end


end

