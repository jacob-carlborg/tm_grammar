module TmGrammar
  module Node
    # This class represent a capture in the grammar.
    #
    # Corresponds to an element in the `captures` key in the TextMate grammar
    # syntax.
    class Capture
      # The name of the capture.
      #
      # Corresponds to `name` in the TextMate grammar syntax.
      #
      # @return [String] the scope name
      attr_accessor :name

      # The patterns of the capture.
      #
      # Corresponds to `patterns` dictionary in the TextMate grammar syntax.
      #
      # @return [Array<Pattern>] the patterns
      attr_reader :patterns

      def initialize
        @patterns = []
      end

      # Adds a pattern to the grammar.
      #
      # @param pattern [TmGrammar::Node::Pattern] the pattern to add
      #
      # @return [void]
      def add_pattern(pattern)
        @patterns << pattern
      end
    end
  end
end
