require 'test_helper'

PatternMatching.configure do |config|
  config.use_proc_helpers = false
end

module ConfigurationTests
  class NoProcHelpers < Minitest::Test
    include PatternMatching

    test "send helper is not defined" do
      refute_respond_to(self, :S)
    end

    test "call helper is not defined" do
      refute_respond_to(self, :C)
    end

  end
end

