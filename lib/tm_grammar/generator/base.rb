module TmGrammar
  module Generator
    class Base
      class Options
        # The set of rules to generate.
        #
        # The rules will be generated as regular patterns, i.e. in the
        # `patterns` array. If this is specified, no other attributes will be
        # generated. This is useful for testing, when testing one pattern at
        # the time.
        #
        # @param rules [Set<String>] the rules to generate
        attr_accessor :rules_to_generate

        # Gets/sets the text used for indentation.
        #
        # @param indent_text [String] the indent text
        #
        # @return [String] the indent text
        attr_accessor :indent_text

        # Gets/sets the indentation.
        #
        # This sets how many times the indentation text should be repeated for
        # each indentation level.
        #
        # @param indent [Integer] the indentation
        #
        # @return [String] the indentation
        attr_accessor :indent

        def initialize
          @indent_text = "\t"
          @indent = 1
        end
      end

      def initialize(options = nil)
        @options = options || Options.new
      end

      protected

      attr_reader :options

      private

      attr_reader :buffer

      def extract_patterns(repository)
        repository.slice(*options.rules_to_generate).values
      end
    end
  end
end
