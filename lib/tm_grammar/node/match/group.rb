module TmGrammar
  module Node
    class Match
      class Group < Base
        attr_reader :node

        def self.deconstruct(group)
          super
          [group.node]
        end

        def initialize(node)
          @node = node
        end

        def ==(other)
          other.is_a?(Group) && node == other.node
        end

        def to_s
          "Group(#{node})"
        end
      end
    end
  end
end
