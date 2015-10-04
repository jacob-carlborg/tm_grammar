module TmGrammar
  class Match
    using PatternMatch

    # Returns the containing pattern node.
    #
    # @return [TmGrammar::Node::Pattern] the pattern node
    attr_reader :pattern

    # Initializes the receiver with the given pattern node and block
    #
    # @example
    #   grammar = TmGrammar::Node::Grammar.new('source.foo')
    #   pattern = TmGrammar::Node::Pattern.new(grammar)
    #   grammar = TmGrammar::Match(pattern, -> {})
    #
    # @param pattern [TmGrammar::Node::Pattern] the pattern this match belongs
    #   to
    #
    # @param block [Proc] the implementation of the match
    def initialize(pattern, block)
      @pattern = pattern
      @grammar = pattern.grammar
      @block = block
    end

    def ==(other)
      pattern == other.pattern && block == other.block
    end

    # Evaluates the match.
    #
    # This will evaluate the block given in the construtor in a match context.
    #
    # @example
    #   i = 0
    #   match = TmGrammar::Match.new do
    #     i += 1
    #   end
    #   match.evaluate
    #   puts i # => 1
    #
    # @return [TmGrammar::Node::Match] a pattern node
    def evaluate
      @evaluate ||= begin
        context = Context.new(pattern)
        root = context.instance_exec(&block)
        e = TmGrammar::Pass::MatchEvaluator.new(grammar, pattern)
        e.evaluate(root)
      end
    end

    protected

    attr_reader :block

    private

    attr_reader :grammar

    class Context
      include TmGrammar::Dsl::Match
    end
  end
end
