module TmGrammar
  class Capture
    # The capture node.
    #
    # Corresponds to an element in `captures` key in the TextMate grammar
    # syntax.
    #
    # @return [TmGrammar::Node::Capture] the capture node
    attr_reader :node

    # Initializes the receiver with the name and block.
    #
    # @param name [String] the name of the capture
    # @param block [Proc] the implementation of the capture
    def initialize(grammar, name, block)
      @grammar = grammar
      @block = block
      @node = TmGrammar::Node::Capture.new
      @node.name = name
    end

    # Evaluates the capture.
    #
    # This will evaluate the block given in the construtor in a capture context.
    #
    # @example
    #   i = 0
    #   block = -> { i += 1 }
    #   pattern = TmGrammar::Node::Capture.new(1, 'foo', block)
    #   pattern.evaluate
    #   puts i # => 1
    #
    # @return [TmGrammar::Node::Pattern] a pattern node
    def evaluate
      if block
        context = Context.new(self, node)
        context.instance_exec(&block)
      end

      node
    end

    # Defines a new pattern on the grammar.
    #
    # @param name [String, nil] the name of the pattern
    # @param block [Proc] the implementation of the pattern
    def define_pattern(name, block)
      pattern_node = TmGrammar::Pattern.new(grammar, block).evaluate
      pattern_node.name = name
      node.add_pattern(pattern_node)
    end

    private

    attr_reader :grammar
    attr_reader :block

    class Context
      include TmGrammar::Dsl::Capture
    end
  end
end
