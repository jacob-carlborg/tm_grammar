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
    end
  end
end
