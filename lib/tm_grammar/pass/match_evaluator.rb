module TmGrammar
  module Pass
    class MatchEvaluator
      using PatternMatch

      private

      Match = TmGrammar::Node::Match
      ZERO_OR_ONE = Match::Repetition::TYPE_OPTIONAL
      ZERO_OR_MORE = Match::Repetition::TYPE_ZERO_OR_MORE
      ONE_OR_MORE = Match::Repetition::TYPE_ONE_OR_MORE

      private_constant :Match

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
          with(Match::And.(left, right)) { evaluate_and(left, right) }
          with(Match::Capture.(n)) { evaluate_capture(n) }
          with(Match::Group.(n)) { evaluate_group(n) }
          with(Match::Or.(left, right)) { evaluate_or(left, right) }
          with(Match::Term.(value)) { evaluate_term(value) }
          with(Match::Repetition.(n, ZERO_OR_ONE)) { evaluate_zero_or_one(n) }
          with(Match::Repetition.(n, ZERO_OR_MORE)) { evaluate_zero_or_more(n) }
          with(Match::Repetition.(n, ONE_OR_MORE)) { evaluate_one_or_more(n) }
          with(String) { evaluate_string(node) }
          with(Regexp) { evaluate_regexp(node) }
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      def evaluate_and(left, right)
        evaluate(left) + evaluate(right)
      end

      def evaluate_capture(node)
        node = evaluate(node)
        "(#{node})"
      end

      def evaluate_group(node)
        node = evaluate(node)
        "(?:#{node})"
      end

      def evaluate_or(left, right)
        left = evaluate(left)
        right = evaluate(right)
        "(?:#{left}|#{right})"
      end

      def evaluate_regexp(regexp)
        regexp.source
      end

      def evaluate_string(string)
        string
      end

      def evaluate_term(value)
        evaluate(value)
      end

      def evaluate_zero_or_one(node)
        evaluate(group(node)) + '?'
      end

      def evaluate_zero_or_more(node)
        evaluate(group(node)) + '*'
      end

      def evaluate_one_or_more(node)
        evaluate(group(node)) + '+'
      end

      def group(node)
        Match::Group.new(node)
      end
    end
  end
end
