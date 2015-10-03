module TmGrammar
  module Node
    class Match
      class Repetition < Base
        attr_reader :node
        attr_reader :type

        TYPE_OPTIONAL = 0
        TYPE_ZERO_OR_MORE = 1
        TYPE_ONE_OR_MORE = 2

        def self.deconstruct(repetition)
          super
          [repetition.node, repetition.type]
        end

        def initialize(node, type)
          @node = node
          @type = type
        end

        def ==(other)
          other.is_a?(Repetition) && node == other.node && type == other.type
        end

        def to_s
          type_string = type_to_string(type)
          "Repetition(#{node}#{type_string})"
        end

        private

        def type_to_string(type)
          case type
          when TYPE_OPTIONAL then '?'
          when TYPE_ZERO_OR_MORE then '*'
          when TYPE_ONE_OR_MORE then '+'
          else raise "Unhandled case #{type}"
          end
        end
      end
    end
  end
end
