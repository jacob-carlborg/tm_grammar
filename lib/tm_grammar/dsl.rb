module TmGrammar
  module Dsl
    module Grammar
      # Returns the grammar node.
      #
      # @return [TmGrammar::Node::Grammar] the grammar node
      attr_reader :node

      # Initializes the receiver with the given grammar node.
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

      # Defines a new pattern.
      #
      # Corresponds to an element in the `patterns` ket in the TextMate grammar
      # syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.pattern 'foo' do
      #   end
      #
      # @param name [String] the name of the pattern
      # @param block [Proc] the implementation of the pattern
      def pattern(name, &block)
        grammar.define_pattern(name, block)
      end
    end

    module Pattern
      # Returns the pattern object.
      #
      # @return [TmGrammar::Pattern] the pattern object
      attr_reader :pattern_object

      # Returns the pattern node.
      #
      # @return [TmGrammar::Node::Pattern] the pattern node
      attr_reader :node

      # Initializes the receiver with the given pattern and pattern node.
      #
      # @param pattern_object [TmGrammar::Pattern] the pattern object
      # @param node [TmGrammar::Node::Pattern] the pattern node
      def initialize(pattern_object, node)
        @pattern_object = pattern_object
        @node = node
      end
    end
  end
end
