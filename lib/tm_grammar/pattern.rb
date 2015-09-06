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
      context = Context.new
      context.instance_exec(&block)
      node
    end

    private

    attr_reader :block

    class Context
    end
  end
end
