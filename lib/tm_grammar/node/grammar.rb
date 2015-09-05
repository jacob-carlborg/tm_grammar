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
