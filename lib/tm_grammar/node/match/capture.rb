module TmGrammar
  module Node
    class Match
      class Capture < Base
        attr_reader :node

        def self.deconstruct(capture)
          super
          [capture.node]
        end

        def initialize(node)
          @node = node
        end

        def ==(other)
          other.is_a?(Capture) && node == other.node
        end

        def to_s
          "Capture(#{node})"
        end
      end
    end
  end
end
