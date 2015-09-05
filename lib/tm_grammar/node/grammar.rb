module TmGrammar
  module Node
    # This class represent a TextMate grammar.
    #
    # Corresponds to the top level dictionary in the TextMate grammar syntax.
    class Grammar
      # The scope name of the grammar.
      #
      # Corresponds to `scopeName` key in the TextMate grammar syntax.
      #
      # @return [String] the scope name
      attr_reader :scope_name

      # Gets/sets the file types of the grammar.
      #
      # Corresponds to `fileTypes` key in the TextMate grammar syntax.
      #
      # @param file_types [Array<String>] the file types to set
      #
      # @return [Array<String>] the file types
      attr_accessor :file_types

      # Gets/sets the file folding start marker of the grammar.
      #
      # Corresponds to `foldingStartMarker` key in the TextMate grammar syntax.
      #
      # @param marker [String, Regexp] the marker to set
      #
      # @return [String, Regexp, nil] the marker, or `nil` if none is set
      attr_accessor :folding_start_marker

      # Gets/sets the file folding stop marker of the grammar.
      #
      # Corresponds to `foldingStopMarker` key in the TextMate grammar syntax.
      #
      # @param marker [String, Regexp] the marker to set
      #
      # @return [String, Regexp, nil] the marker, or `nil` if none is set
      attr_accessor :folding_stop_marker

      # Gets/sets the first line match of the grammar.
      #
      # Corresponds to `firstLineMatch` key in the TextMate grammar syntax.
      #
      # @param match [String, Regexp] the regular expression to set
      #
      # @return [String, Regexp, nil] the match, or `nil` if none is set
      attr_accessor :first_line_match

      # Initializes the receiver with the given scope name.
      #
      # @param scope_name [String] the scope name of the grammar.
      #
      def initialize(scope_name)
        @scope_name = scope_name
      end
    end
  end
end
