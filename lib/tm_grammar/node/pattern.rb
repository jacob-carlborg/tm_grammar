module TmGrammar
  module Node
    # This class represent a pattern rule in the grammar.
    #
    # Corresponds to an element in `patterns` attribute in the TextMate grammar
    # syntax.
    class Pattern
      # The grammar node this pattern belongs to.
      #
      # @return [TmGrammar::Node::Grammar] the grammar
      attr_reader :grammar

      # Gets/sets name of the pattern.
      #
      # Corresponds to the `name` key in the TextMate grammar syntax.
      #
      # @param name [String] the name to set
      #
      # @return [String] the set name, or `nil` if not set
      attr_accessor :name

      # Gets/sets match for the pattern.
      #
      # Corresponds to the `match` key in the TextMate grammar syntax.
      #
      # @param match [String, Regexp] the match to set
      #
      # @return [String, Regexp] the set match, or `nil` if not set
      attr_accessor :match

      # Gets/sets begin match for the pattern.
      #
      # Corresponds to the `begin` key in the TextMate grammar syntax.
      #
      # @param match [String, Regexp] the begin match to set
      #
      # @return [String, Regexp] the set being match, or `nil` if not set
      attr_accessor :begin

      # Gets/sets end match for the pattern.
      #
      # Corresponds to the `end` key in the TextMate grammar syntax.
      #
      # @param match [String, Regexp] the end match to set
      #
      # @return [String, Regexp] the set end match, or `nil` if not set
      attr_accessor :end

      # Gets/sets content name for the pattern.
      #
      # Corresponds to the `contentName` key in the TextMate grammar syntax.
      #
      # @param content_name [String, Regexp] the content name to set
      #
      # @return [String, Regexp] the set content name, or `nil` if not set
      attr_accessor :content_name

      # Gets/sets comment of the pattern.
      #
      # Corresponds to the `comment` key in the TextMate grammar syntax.
      #
      # @param comment [String] the comment to set
      #
      # @return [String] the set comment, or `nil` if not set
      attr_accessor :comment

      # Gets/sets disabled state of the pattern.
      #
      # Corresponds to the `disabled` key in the TextMate grammar syntax.
      #
      # @param disabled [Boolean] the state disabled to set
      #
      # @return [Boolean] the set state disabled, or `nil` if not set
      attr_accessor :disabled

      # Gets/sets include for the pattern.
      #
      # Corresponds to the `include` key in the TextMate grammar syntax.
      #
      # @param name [String, Regexp] the name of the include to set
      #
      # @return [String, Regexp] the set include name, or `nil` if not set
      attr_accessor :include

      # The scope captures of the pattern.
      #
      # Corresponds to the `captures` key in the TextMate grammar syntax.
      #
      # @return [<TmGrammar::Node::Captures>] the captures
      attr_reader :captures

      # The scope begin captures of the pattern.
      #
      # Corresponds to the `beginCaptures` key in the TextMate grammar syntax.
      #
      # @return [<TmGrammar::Node::Capture>] the captures
      attr_reader :begin_captures

      # The scope end captures of the pattern.
      #
      # Corresponds to the `endCaptures` key in the TextMate grammar syntax.
      #
      # @return [<TmGrammar::Node::Capture>] the captures
      attr_reader :end_captures

      # The nested patterns of the pattern.
      #
      # Corresponds to `patterns` key in the TextMate grammar syntax.
      #
      # @return [<Pattern>] the patterns
      attr_reader :patterns

      def initialize(grammar)
        @grammar = grammar
        @captures = {}
        @begin_captures = {}
        @end_captures = {}
        @patterns = []
        @capture_number = 0
      end

      # Adds a capture to the pattern.
      #
      # @param key [Integer] the key of the capture
      # @param pattern [TmGrammar::Node::Capture] the capture to add
      #
      # @return [void]
      def add_capture(key, capture)
        @captures[key] = capture
      end

      # Adds a begin capture to the pattern.
      #
      # @param key [Integer] the key of the begin capture
      # @param pattern [TmGrammar::Node::Capture] the capture to add
      #
      # @return [void]
      def add_begin_capture(key, capture)
        @begin_captures[key] = capture
      end

      # Adds a end capture to the pattern.
      #
      # @param key [Integer] the key of the end capture
      # @param pattern [TmGrammar::Node::Capture] the capture to add
      #
      # @return [void]
      def add_end_capture(key, capture)
        @end_captures[key] = capture
      end

      # Adds a pattern to the pattern.
      #
      # @param pattern [TmGrammar::Node::Pattern] the pattern to add
      #
      # @return [void]
      def add_pattern(pattern)
        @patterns << pattern
      end

      def new_capture_number
        @capture_number += 1
      end
    end
  end
end
