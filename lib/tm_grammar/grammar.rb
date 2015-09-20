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
    def initialize(scope_name, block)
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
    # @return [TmGrammar::Node::Grammar] the grammar node
    def evaluate
      context = Context.new(self, node)
      context.instance_exec(&block)
      node
    end

    # Defines a new pattern on the grammar.
    #
    # @param name [String, nil] the name of the pattern
    # @param block [Proc] the implementation of the pattern
    def define_pattern(name, block)
      pattern_node = TmGrammar::Pattern.new(block).evaluate
      pattern_node.name = name
      node.add_pattern(pattern_node)
    end

    # Defines a new rule in the repository on the grammar.
    #
    # @param name [String] the name of the rule
    # @param block [Proc] the implementation of the rule
    def define_rule(name, block)
      pattern_node = TmGrammar::Pattern.new(block).evaluate
      node.add_rule(name, pattern_node)
    end

    private

    attr_reader :block

    class Context
      include TmGrammar::Dsl::Grammar
    end
  end
end
