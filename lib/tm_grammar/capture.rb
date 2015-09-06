module TmGrammar
  class Capture
    # The capture node.
    #
    # Corresponds to an element in `captures` key in the TextMate grammar
    # syntax.
    #
    # @return [TmGrammar::Node::Capture] the capture node
    attr_reader :node

    # Initializes the receiver with the number, name and block.
    #
    # @param number [Integer] the number of the capture
    # @param name [String] the name of the capture
    # @param block [Proc] the implementation of the capture
    def initialize(number, name, block)
      @number = number
      @name = name
      @block = block
      @node = TmGrammar::Node::Capture.new(number)
      @node.name = name
    end
  end
end
