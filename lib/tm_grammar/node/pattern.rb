module TmGrammar
  module Node
    # This class represent a pattern rule in the grammar.
    #
    # Corresponds to an element in `patterns` attribute in the TextMate grammar
    # syntax.
    class Pattern
      # Gets/sets the scope name of the pattern.
      #
      # Corresponds to `name` in the TextMate grammar syntax.
      #
      # @param name [String] the name to set
      #
      # @return [String] the scope name
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
    end
  end
end
