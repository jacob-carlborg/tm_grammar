module TmGrammar
  module Node
    # This class represent a capture in the grammar.
    #
    # Corresponds to an element in the `captures` key in the TextMate grammar
    # syntax.
    class Capture
      # The number of the capture.
      #
      # Corresponds to numeric key inside the `captures` key in the TextMate
      # grammar syntax.
      #
      # @return [Integer] the number
      attr_reader :number

      # The name of the capture.
      #
      # Corresponds to `name` in the TextMate grammar syntax.
      #
      # @return [String] the scope name
      attr_reader :name

      # Initializes the receiver with the given number and name.
      #
      # @param number [Integer] the number of the capture
      # @param name [String] the name of the capture
      def initialize(number, name)
        @number = number
        @name = name
      end
    end
  end
end
