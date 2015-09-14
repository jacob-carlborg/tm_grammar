module TmGrammar
  class Pattern
    # The pattern node.
    #
    # Corresponds to an element in `patterns` key in the TextMate grammar
    # syntax.
    #
    # @return [TmGrammar::Node::Pattern] the pattern node
    attr_reader :node

    def initialize(block)
      @block = block
      @node = TmGrammar::Node::Pattern.new
    end

    # Evaluates the pattern.
    #
    # This will evaluate the block given in the construtor in a pattern context.
    #
    # @example
    #   i = 0
    #   pattern = TmGrammar::Node::Pattern('foo') do
    #     i += 1
    #   end
    #   pattern.evaluate
    #   puts i # => 1
    #
    # @return [TmGrammar::Node::Pattern] a pattern node
    def evaluate
      context = Context.new(self, node)
      context.instance_exec(&block)
      node
    end

    # Defines a new capture on the pattern.
    #
    # @param key [key] the key of the capture
    # @param name [String] the name of the capture
    # @param block [Proc] the implementation of the capture
    def define_capture(key, name = nil, block = nil)
      capture_node = TmGrammar::Capture.new(name, block).evaluate
      node.add_capture(key, capture_node)
    end

    # Defines a new begin capture on the pattern.
    #
    # @param key [Integer] the key of the capture
    # @param name [String] the name of the capture
    # @param block [Proc] the implementation of the capture
    def define_begin_capture(key, name = nil, block = nil)
      capture_node = TmGrammar::Capture.new(name, block).evaluate
      node.add_begin_capture(key, capture_node)
    end

    # Defines a new end capture on the pattern.
    #
    # @param key [Integer] the key of the capture
    # @param name [String] the name of the capture
    # @param block [Proc] the implementation of the capture
    def define_end_capture(key, name = nil, block = nil)
      capture_node = TmGrammar::Capture.new(name, block).evaluate
      node.add_end_capture(key, capture_node)
    end

    # Defines a new nested pattern on the pattern.
    #
    # @param name [String, nil] the name of the pattern
    # @param block [Proc] the implementation of the pattern
    def define_pattern(name, block)
      pattern_node = TmGrammar::Pattern.new(block).evaluate
      pattern_node.name = name
      node.add_pattern(pattern_node)
    end

    private

    attr_reader :block

    class Context
      include TmGrammar::Dsl::Pattern
    end
  end
end
