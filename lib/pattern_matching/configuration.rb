module PatternMatching
  ##
  # Available configuration options are:
  #
  # - use_proc_helpers: controls whether or not helpers for sending
  #   messages and calling a method in the local context are included
  #   with this module.
  #
  # - use_binding_helper: controls whether or not bindings are enabled (and thus)
  #   whether or not helpers are included.
  #
  # - send_helper: the method name used as the proc helper for
  #   "sending a message" to the object when matching.
  #
  # - call_helper: the method name used as the proc helper for "calling a
  #   method in the current context" with the object as an argument when matching.
  #
  # - binding_helper: the method name used as the binding set for each match.
  class Configuration

    def self.default
      new(true, true, :S, :C, :B)
    end

    attr_accessor :use_proc_helpers,
                  :use_binding_helper,
                  :send_helper,
                  :call_helper,
                  :binding_helper

    def initialize(use_proc_helpers, use_binding_helper, send_helper, call_helper, binding_helper)
      @use_proc_helpers   = use_proc_helpers
      @use_binding_helper = use_binding_helper
      @send_helper        = send_helper
      @call_helper        = call_helper
      @binding_helper     = binding_helper
    end


    def default_proc_helpers?
      :S == send_helper && :C == call_helper
    end


    def default_binding_helper?
      :B == binding_helper
    end

  end
end
