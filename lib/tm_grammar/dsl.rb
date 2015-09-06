module TmGrammar
  module Dsl
    module Grammar
      # Returns the grammar node.
      #
      # @return [TmGrammar::Node::Grammar] the grammar node
      attr_reader :node

      # initializes the receiver with the given grammar node.
      #
      # @param node [TmGrammar::Node::Grammar] the grammar node
      def initialize(node)
        @node = node
      end

      # Sets the file types.
      #
      # Corresponds to the `fileTypes` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.file_types %w(foo bar)
      #
      # @param file_types [<String>] the file types to set
      def file_types(file_types)
        node.file_types = file_types
      end

      # Sets the folding start marker.
      #
      # Corresponds to the `foldingStartMarker` key in the TextMate grammar
      # syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.folding_start_marker /^\s*\}/
      #
      # @param marker [String] the marker to set
      def folding_start_marker(marker)
        node.folding_start_marker = marker
      end

      # Sets the folding stop marker.
      #
      # Corresponds to the `foldingStopMarker` key in the TextMate grammar
      # syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.folding_stop_marker /^\s*\}/
      #
      # @param marker [String] the marker to set
      def folding_stop_marker(marker)
        node.folding_stop_marker = marker
      end
    end
  end
end
