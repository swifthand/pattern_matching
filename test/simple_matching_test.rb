require 'test_helper'

class SimpleMatchingTest < Minitest::Test
  include PatternMatching


  test "matches status and exact value" do
    result = Pattern(     :ok, [1, 2, 3])
    assert_match(result,  :ok, [1, 2, 3])
    refute_match(result,  :ok, [1, 2])
    refute_match(result,  :ok, [3, 2, 1])
    refute_match(result,  :ok, [])
  end


  test "matches status without value" do
    result = Pattern(     :ok)
    assert_match(result,  :ok)
    assert_match(result,  Any)
    refute_match(result,  :ok, [1, 2, 3])
    refute_match(result,  :ok, Any)
    refute_match(result,  Any, Any)
  end


  test "matches class hierarchy" do
    result = Pattern(     :ok, [1, 2, 3])
    assert_match(result,  :ok, Array)
    assert_match(result,  Symbol, [1, 2, 3])
    refute_match(result,  :ok, [Array])
    refute_match(result,  :ok, [Fixnum])
    refute_match(result,  :ok, String)
    refute_match(result,  :ok, Fixnum)
    refute_match(result,  Symbol, [])
  end


  test "matches range inclusion" do
    result = Pattern(     5)
    assert_match(result,  (1..10))
    refute_match(result,  (1...5))
  end


  test "matches by calling procs or lambdas" do
    result = Pattern(     5)

    assert_match(result,  ->(val)   { true })
    assert_match(result,  Proc.new  { true })
    assert_match(result,  :odd?.to_proc)

    refute_match(result,  Proc.new  { false })
    refute_match(result,  :even?.to_proc)
  end


  test "matches arrays recursively" do
    result = Pattern(     :ok, [1, 2, 3])

    assert_match(result,  :ok, [1, Any, 3])
    assert_match(result,  :ok, [Any, Any, Any])
    refute_match(result,  :ok, [1, Any])

    assert_match(result,  :ok, [1, :even?.to_proc, 3])
    refute_match(result,  :ok, [1, :odd?.to_proc, 3])

    assert_match(result,  Symbol, [1, Numeric, 3])
    refute_match(result,  Symbol, [1, Float, 3])

    assert_match(result,  Symbol, [1, (0..10), 3])
    refute_match(result,  Symbol, [1, (5..10), 3])
  end


  test "matches hash strucutre" do
    result = Pattern(     :ok, { a: 1, b: 2, c: 3 })
    assert_match(result,  :ok, { a: 1, b: 2, c: 3 })
    assert_match(result,  :ok, { a: Any, b: Any, c: Any })
    assert_match(result,  :ok, { a: Any, b: Any, c: Any })
    refute_match(result,  :ok, {})
    refute_match(result,  :ok, { d: Any})
    refute_match(result,  :ok, { a: 1,    b: 2,   c: 3,   d: 4 })
    refute_match(result,  :ok, { a: 1,    b: 2,   c: 3,   d: Any })
    refute_match(result,  :ok, { a: Any,  b: Any, c: Any, d: Any })
    refute_match(result,  :ok, { a: 1 })
    refute_match(result,  :ok, { a: '1',  b: '2', c: '3' })
    refute_match(result,  :ok, { a: Any,  b: '2', c: Any })
  end


  test "matches Any deeply nested arrays" do
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
        [Numeric, 4, :five],
        "baz"
      ],
    ])

    refute_match(result, [
      1,
      "foo",
      2,
      [ "bar",
        [3, 4, 5],
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
