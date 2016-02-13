module TmGrammar
  module Node
    class Match
      class Capture < Base
        attr_reader :node
        attr_reader :name

        def self.deconstruct(capture)
          super
          name = capture.name
          name ? [capture.node, name] : [capture.node]
        end

        def initialize(node, name = nil)
          @node = node
          @name = name
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
