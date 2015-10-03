module TmGrammar
  module Node
    class Match
      class Term < Base
        attr_reader :value

        def self.deconstruct(term)
          super
          [term.value]
        end

        def initialize(value)
          @value = value
        end

        def ==(other)
          other.is_a?(Term) && value == other.value
        end

        def to_s
          "Term(#{value})"
        end
      end
    end
  end
end
