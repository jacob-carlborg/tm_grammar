module TmGrammar
  module Util
    class Buffer
      def initialize(indentation = "\t")
        @internal_buffer = StringIO.new
        @level = 0
        @indent = false
        @indentation = indentation
      end

      def append(*values)
        values.each { |v| _append(v) }
        self
      end

      def <<(value)
        append(value)
      end

      def to_s
        internal_buffer.string
      end

      def indent(&block)
        @level += 1
        block.call
        self
      ensure
        @level -= 1
      end

      def unindent(&block)
        @level -= 1
        block.call
        self
      ensure
        @level += 1
      end

      def join(*values, separator: ';')
        values.each_with_index do |value, index|
          if index == 0
            append(value)
          else
            _indent
            append(separator)
            append(value)
          end
        end
      end

      private

      attr_reader :indentation
      attr_reader :internal_buffer
      attr_reader :level

      def _append(value)
        if value == Newline
          internal_buffer << "\n"
          @indent = true
        else
          _indent
          internal_buffer << value
          @indent = false
        end
      end

      def _indent
        internal_buffer << indentation * @level if @indent
      end
    end

    class Newline
    end

    def nl
      Newline
    end
  end
end
