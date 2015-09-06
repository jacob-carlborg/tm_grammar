module TmGrammar
  # This class represent the implementation of a grammar.
  class Grammar
    # The grammar node.
    #
    # Corresponds to the top level dictionary element in the TextMate grammar
    # syntax.
    #
    # @return [TmGrammar::Node::Grammar] the grammar node
    attr_reader :node

    # Initializes the receiver with the given scope name and block
    #
    # @example
    #   grammar = TmGrammar::Node::Grammar('source.foo') do
    #   end
    #
    # @param scope_name [String] the scope name of the grammar
    # @param block [Proc] the implementation of the grammar
    def initialize(scope_name, &block)
      @node = TmGrammar::Node::Grammar.new(scope_name)
      @block = block
    end

    # Evaluates the grammar.
    #
    # This will evaluate the block given in the construtor in a grammar context.
    #
    # @example
    #   i = 0
    #   grammar = TmGrammar::Node::Grammar('source.foo') do
    #     i += 1
    #   end
    #   grammar.evaluate
    #   puts i # => 1
    #
    # @return [void]
    def evaluate
      context = Context.new
      context.instance_exec(&block)
    end

    private

    attr_reader :block

    class Context
    end
  end
end
