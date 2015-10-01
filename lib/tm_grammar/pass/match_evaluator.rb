module TmGrammar
  module Pass
    class MatchEvaluator
      using PatternMatch

      private

      attr_reader :grammar
      attr_reader :pattern

      public

      def initialize(grammar, pattern)
        @grammar = grammar
        @pattern = pattern
      end

      # rubocop:disable Metrics/AbcSize
      def evaluate(node)
        match(node) do
          with(String) { evaluate_string(node) }
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      def evaluate_string(string)
        string
      end
    end
  end
end
