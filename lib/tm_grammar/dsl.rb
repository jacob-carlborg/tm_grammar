module TmGrammar
  module Dsl
    module Global
      def grammar(scope_name, &block)
        TmGrammar::Grammar.new(scope_name, block).evaluate
      end
    end

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

      # Sets the comment of the grammar.
      #
      # Corresponds to the `comment` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.comment 'foo'
      #
      # @param name [String] the name to set
      def comment(comment)
        node.comment = comment
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

      # Sets the key equivalent of the grammar.
      #
      # Corresponds to the `keyEquivalent` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.keyEquivalent '^~D'
      #
      # @param name [String] the name to set
      def key_equivalent(key_equivalent)
        node.key_equivalent = key_equivalent
      end

      # Sets the uuid of the pattern.
      #
      # Corresponds to the `uuid` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.uuid 'foo'
      #
      # @param uuid [String] the uuid to set
      def uuid(uuid)
        node.uuid = uuid
      end

      # Sets the first line match of the grammar.
      #
      # Corresponds to the `firstLineMatch` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.first_line_match '^#!.*\bg?dmd\b.'
      #
      # @param name [String] the name to set
      def first_line_match(first_line_match)
        node.first_line_match = first_line_match
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

      # Defines a new rule in the repository.
      #
      # Corresponds to an element in the `repository` key in the TextMate
      # grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.rule 'foo' do
      #   end
      #
      # @param name [String] the name of the rule
      # @param block [Proc] the implementation of the rule
      def rule(name, &block)
        grammar.define_rule(name, block)
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

      # Sets the comment of the pattern.
      #
      # Corresponds to the `comment` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.comment 'foo'
      #
      # @param name [String] the name to set
      def comment(comment)
        node.comment = comment
      end

      # Sets the disabled of the pattern.
      #
      # Corresponds to the `disabled` key in the TextMate grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Pattern
      #   end
      #
      #   Foo.new.disabled true
      #
      # @param value [Boolean] the value to set
      def disabled(value)
        node.disabled = value
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

      # Defines a begin capture for the pattern.
      #
      # Corresponds to an element in the `beginCaptures` key in the TextMate
      # grammar syntax.
      #
      # @example Begin capture with name
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.begin_capture 1, 'foo'
      #
      # @example Begin capture with block
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.begin_capture 1 do
      #   end
      #
      # @example Begin capture with name and block
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.begin_capture 1, 'foo' do
      #   end
      #
      # @param key [Integer] the key of the capture
      #
      # @param name [String] the name of the begin capture. Corresponds to the
      #   `beginCapture` key inside the capture value in the TextMate grammar
      #   syntax.
      #
      # @param block [Proc] the implementation of the capture
      def begin_capture(key, name = nil, &block)
        pattern_object.define_begin_capture(key, name, block)
      end

      # Defines a end capture for the pattern.
      #
      # Corresponds to an element in the `endCaptures` key in the TextMate
      # grammar syntax.
      #
      # @example End capture with name
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.end_capture 1, 'foo'
      #
      # @example End capture with block
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.end_capture 1 do
      #   end
      #
      # @example End capture with name and block
      #   class Foo
      #     include TmGrammar::Dsl::Grammar
      #   end
      #
      #   Foo.new.end_capture 1, 'foo' do
      #   end
      #
      # @param key [Integer] the key of the capture
      #
      # @param name [String] the name of the end capture. Corresponds to the
      #   `endCapture` key inside the capture value in the TextMate grammar
      #   syntax.
      #
      # @param block [Proc] the implementation of the capture
      def end_capture(key, name = nil, &block)
        pattern_object.define_end_capture(key, name, block)
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

    module Capture
      # Returns the capture.
      #
      # @return [TmCapture:::Capture] the capture
      attr_reader :capture

      # Returns the capture node.
      #
      # @return [TmCapture::Node::Capture] the capture node
      attr_reader :node

      # Initializes the receiver with the given capture and capture node.
      #
      # @param capture [TmCapture::Capture] the capture
      # @param node [TmCapture::Node::Capture] the capture node
      def initialize(capture, node)
        @capture = capture
        @node = node
      end

      # Defines a new pattern.
      #
      # Corresponds to an element in the `patterns` dictionary in the TextMate
      # grammar syntax.
      #
      # @example
      #   class Foo
      #     include TmGrammar::Dsl::Capture
      #   end
      #
      #   Foo.new.pattern 'foo' do
      #   end
      #
      # @param name [String] the name of the pattern
      # @param block [Proc] the implementation of the pattern
      def pattern(name = nil, &block)
        capture.define_pattern(name, block)
      end
    end
  end
end
