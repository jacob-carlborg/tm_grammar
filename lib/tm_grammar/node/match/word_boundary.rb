module TmGrammar
  module Node
    class Match
      class WordBoundary < Base
        attr_reader :node

        def self.deconstruct(word_boundary)
          super
          [word_boundary.node]
        end

        def initialize(node)
          @node = node
        end

        def ==(other)
          other.is_a?(WordBoundary) && node == other.node
        end

        def to_s
          "WordBoundary(#{node})"
        end
      end
    end
  end
end
