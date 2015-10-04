module TmGrammar
  module Node
    class Match
      class RuleReference < Base
        include TmGrammar::Util::Util

        attr_reader :rule
        attr_reader :containing_pattern

        def self.deconstruct(rule_refernece)
          super
          [
            rule_refernece.rule,
            rule_refernece.containing_pattern,
            rule_refernece.referenced_pattern
          ]
        end

        def initialize(rule, containing_pattern)
          @rule = rule
          @containing_pattern = containing_pattern
        end

        def referenced_pattern
          pattern = containing_pattern.grammar.repository[rule]
          enforce(pattern) { "Undeclared rule '#{rule}'" }
        end

        def ==(other)
          other.is_a?(RuleReference) && rule == other.rule &&
            containing_pattern == other.containing_pattern
        end

        def to_s
          "RuleReference(#{rule})"
        end
      end
    end
  end
end
