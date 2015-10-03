module TmGrammar
  module Node
    class Match
      class Binary < Base
        attr_reader :left
        attr_reader :right

        def self.deconstruct(node)
          super
          [node.left, node.right]
        end

        def initialize(left, right)
          @left = left
          @right = right
        end

        def ==(other)
          left == other.left && right == other.right
        end
      end
    end
  end
end
