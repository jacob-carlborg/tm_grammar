module TmGrammar
  module Node
    # This class represent a pattern rule in the grammar.
    #
    # Corresponds to an element in `patterns` attribute in the TextMate grammar
    # syntax.
    class Pattern
      # The scope name of the pattern.
      #
      # Corresponds to `name` in the TextMate grammar syntax.
      #
      # @return [String] the scope name
      attr_reader :name

      def initialize(name)
        @name = name
      end
    end
  end
end
