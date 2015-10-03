module TmGrammar
  module Node
    class Match
      class Base
        def self.deconstruct(node)
          raise PatternMatch::PatternNotMatch unless node.is_a?(self)
        end

        def +(other)
          And.new(self, other)
        end

        def |(other)
          Or.new(self, other)
        end
      end
    end
  end
end
