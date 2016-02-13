module TmGrammar
  module Pass
    # rubocop:disable Metrics/ClassLength
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
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Style/LambdaCall
      def evaluate(node, top_level_ref = false)
        match(node) do
          with(Match::And.(left, right)) do
            evaluate_and(left, right, top_level_ref)
          end

          with(Match::Capture.(n)) do
            evaluate_capture(n, top_level_ref)
          end

          with(Match::Capture.(n, name)) do
            evaluate_named_capture(n, name, top_level_ref)
          end

          with(Match::Group.(n)) do
            evaluate_group(n, top_level_ref)
          end

          with(Match::Or.(left, right)) do
            evaluate_or(left, right, top_level_ref)
          end

          with(Match::Term.(value)) do
            evaluate_term(value)
          end

          with(Match::Repetition.(n, ZERO_OR_ONE)) do
            evaluate_zero_or_one(n, top_level_ref)
          end

          with(Match::Repetition.(n, ZERO_OR_MORE)) do
            evaluate_zero_or_more(n, top_level_ref)
          end

          with(Match::Repetition.(n, ONE_OR_MORE)) do
            evaluate_one_or_more(n, top_level_ref)
          end

          with(Match::RuleReference.(rule, containing_pattern, ref_pattern)) do
            evaluate_rule_reference(
              rule, containing_pattern, ref_pattern, top_level_ref
            )
          end

          with(TmGrammar::Node::Pattern) do
            evaluate_pattern(node, top_level_ref)
          end

          with(TmGrammar::Match) do
            evaluate(node.evaluate(top_level_ref))
          end

          with(String) { evaluate_string(node) }
          with(Regexp) { evaluate_regexp(node) }
          with(_) { raise "Unhandled node #{node.class}" }
        end
      end
      # rubocop:enable Style/LambdaCall
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      private

      def evaluate_and(left, right, top_level_ref)
        evaluate(left, top_level_ref) + evaluate(right, top_level_ref)
      end

      def evaluate_capture(node, top_level_ref)
        node = evaluate(node, top_level_ref)
        top_level_ref ? evaluate(group(node)) : "(#{node})"
      end

      def evaluate_named_capture(node, name, top_level_ref)
        node = evaluate(node, top_level_ref)
        top_level_ref ? evaluate(group(node)) : "(?<#{name}>#{node})"
      end

      def evaluate_group(node, top_level_ref)
        node = evaluate(node, top_level_ref)
        "(?:#{node})"
      end

      def evaluate_or(left, right, top_level_ref)
        left = evaluate(left, top_level_ref)
        right = evaluate(right, top_level_ref)
        "(?:#{left}|#{right})"
      end

      def evaluate_pattern(pattern, top_level_ref)
        evaluate(pattern.match, top_level_ref)
      end

      def evaluate_regexp(regexp)
        regexp.source
      end

      def evaluate_rule_reference(rule, containing_pattern, referenced_pattern,
        top_level_ref)

        block = -> { pattern { include "##{rule}" } }
        capture = TmGrammar::Capture.new(containing_pattern.grammar, nil, block)
        containing_pattern.add_capture(rule, capture.evaluate)

        pattern = evaluate(referenced_pattern, true)
        node = top_level_ref ? group(pattern) : capture(pattern, rule)
        evaluate(node, top_level_ref)
      end

      def evaluate_string(string)
        string
      end

      def evaluate_term(value)
        evaluate(value)
      end

      def evaluate_zero_or_one(node, top_level_ref)
        evaluate(group(node), top_level_ref) + '?'
      end

      def evaluate_zero_or_more(node, top_level_ref)
        evaluate_repetition(node, '*', top_level_ref)
      end

      def evaluate_one_or_more(node, top_level_ref)
        evaluate_repetition(node, '+', top_level_ref)
      end

      def evaluate_repetition(node, suffix, top_level_ref)
        if node.is_a?(Match::RuleReference)
          pattern = Match::And.new(group(node.referenced_pattern), suffix)
          evaluate_rule_reference(
            node.rule, node.containing_pattern, pattern, top_level_ref
          )
        else
          evaluate(group(node), top_level_ref) + suffix
        end
      end

      def capture(node, name = nil)
        Match::Capture.new(node, name)
      end

      def group(node)
        Match::Group.new(node)
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
