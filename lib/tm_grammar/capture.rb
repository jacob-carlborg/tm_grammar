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
    def initialize(name, block)
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
        context = Context.new
        context.instance_exec(&block)
      end

      node
    end

    private

    attr_reader :block

    class Context
    end
  end
end
