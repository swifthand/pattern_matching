require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/reporters/turn_again_reporter'
Minitest::Reporters.use!(Minitest::Reporters::TurnAgainReporter.new)

# Require ourselves.
require 'pattern_matching'

##
# Blatantly stolen from ActiveSupport::Testing::Declarative
# Allows for test files such as
#   test "verify something" do
#     ...
#   end
# which become methods named test_verify_something, leaving a visual difference
# between tests themselves and any helper methods declared in the usual
# manner of `def some_helper_method`.
module DeclarativeTests
  def test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end
end


class Minitest::Test
  extend DeclarativeTests

  def assert_match(result, *pattern)
    case result
    when Match(*pattern)
      assert(true)
    else
      assert(false, "Result of #{result.pattern}' should match pattern '#{pattern.join(', ')}'")
    end
  end


  def refute_match(result, *pattern)
    case result
    when Match(*pattern)
      assert(false, "Result of '#{result.pattern}' should not match pattern '#{pattern.join(', ')}'")
    else
      assert(true)
    end
  end

end
