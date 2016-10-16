require 'test_helper'

PatternMatching.default_configuration!

class WildcardTest < Minitest::Test
  include PatternMatching


  test "matches with Any as items or enumerables" do
    result = Pattern(     :ok, [1, 2, 3])
    assert_match(result,  :ok, Any)
    assert_match(result,  Any, [1, 2, 3])
    assert_match(result,  Any, Any)
    refute_match(result,  Any, Any, Any)
  end


  test "matches Any internal to arrays" do
    result = Pattern(     [1, 2, 3])
    assert_match(result,  [1, Any, 3])
    assert_match(result,  [Any, Any, Any])
    refute_match(result,  [1, Any])
  end


  test "matches Any internal to hashes" do
    result = Pattern(     { a: 1, b: 2, c: 3 })

    assert_match(result,  Any)
    assert_match(result,  { a: 1, b: 2, Any => Any })
    assert_match(result,  { a: 1, b: 2, Any => 3 })
    assert_match(result,  { a: Any, b: Any, c: Any })
    assert_match(result,  { a: Any, b: Any, c: Any })

    refute_match(result,  {})
    refute_match(result,  { d: Any})
    refute_match(result,  { a: 1,     b: 2,   Any => 4 })
    refute_match(result,  { a: 1,     b: 2,   c: 3,   d: Any })
    refute_match(result,  { a: Any,   b: Any, c: Any, d: Any })
    refute_match(result,  { a: 1 })
    refute_match(result,  { a: '1',   b: '2', c: '3' })
    refute_match(result,  { a: Any,   b: '2', c: Any })
  end


  test "matches Any in deeply nested arrays" do
    deeply_nested = [
      1,
      "foo",
      2,
      [ "bar",
        [3, 4, :five],
        "baz"
      ],
    ]
    result = Pattern(deeply_nested)

    assert_match(result, [
      1,
      "foo",
      2,
      [ "bar",
        [Numeric, Any, :five],
        "baz"
      ],
    ])

    assert_match(result, [
      Any,
      Any,
      Any,
      [ Any,
        [Any, Any, Any],
        Any
      ],
    ])
  end

end
