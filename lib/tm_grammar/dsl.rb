module TmGrammar
  module Dsl
    module Grammar
      # Returns the grammar.
      #
      # @return [TmGrammar:::Grammar] the grammar
      attr_reader :grammar

      # Returns the grammar node.
      #
      # @return [TmGrammar::Node::Grammar] the grammar node
      attr_reader :node

      # Initializes the receiver with the given grammar and grammar node.
      #
      # @param grammar [TmGrammar::Grammar] the grammar
      # @param node [TmGrammar::Node::Grammar] the grammar node
      def initialize(grammar, node)
        @grammar = grammar
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
      def pattern(name = nil, &block)
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

      # Sets the name of the pattern.
      #
      # Corresponds to the `name` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.name 'foo'
      #
      # @param name [String] the name to set
      def name(name)
        node.name = name
      end

      # Sets the match of the pattern.
      #
      # Corresponds to the `match` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.match 'foo'
      #
      # @param match [String, Regexp] the match to set
      def match(match)
        node.match = match
      end

      # Sets the begin match of the pattern.
      #
      # Corresponds to the `begin` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.begin 'foo'
      #
      # @param match [String, Regexp] the match to set
      def begin(match)
        node.begin = match
      end

      # Sets the end match of the pattern.
      #
      # Corresponds to the `end` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.end 'foo'
      #
      # @param match [String, Regexp] the match to set
      def end(match)
        node.end = match
      end

      # Sets the content name of the pattern.
      #
      # Corresponds to the `contentName` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.content_name 'foo'
      #
      # @param name [String] the name to set
      def content_name(name)
        node.content_name = name
      end

      # Defines a capture for the pattern.
      #
      # Corresponds to an element in the `captures` key in the TextMate grammar
      # syntax.
      #
      # @example Capture with name
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.capture 1, 'foo'
      #
      # @example Capture with block
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.capture 1 do
      #   end
      #
      # @example Capture with name and block
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.capture 1, 'foo' do
      #   end
      #
      # @param key [Integer] the key of the capture
      #
      # @param name [String] the name of the capture. Corresponds to the `name`
      #   key inside the capture value in the TextMate grammar syntax.
      #
      # @param block [Proc] the implementation of the capture
      def capture(key, name = nil, &block)
        pattern_object.define_capture(key, name, block)
      end

      # Defines a new pattern.
      #
      # Corresponds to an element in the `patterns` key in the TextMate grammar
      # syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.pattern 'foo' do
      #   end
      #
      # @param name [String] the name of the pattern
      # @param block [Proc] the implementation of the pattern
      def pattern(name = nil, &block)
        pattern_object.define_pattern(name, block)
      end

      # Sets the include of the pattern.
      #
      # Corresponds to the `include` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.include 'foo'
      #
      # @param name [String] the name to set
      def include(name)
        node.include = name
      end
    end
  end
end
