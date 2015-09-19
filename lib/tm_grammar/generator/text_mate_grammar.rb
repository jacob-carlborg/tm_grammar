module TmGrammar
  module Generator
    class TextMateGrammar
      using PatternMatch
      include TmGrammar::Node
      include TmGrammar::Util

      def initialize(buffer = nil)
        @buffer = buffer || TmGrammar::Util::Buffer.new
      end

      def generate(node)
        match(node) do
          with(TmGrammar::Node::Grammar) { generate_grammar(node) }
          with(TmGrammar::Node::Pattern) { generate_pattern(node) }
          with(TmGrammar::Node::Capture) { generate_capture(node) }
          with(_) { raise "Unhandled node type #{node.class.name}" }
        end
      end

      private

      attr_reader :buffer

      # rubocop:disable Metrics/AbcSize
      def generate_grammar(grammar)
        buffer.append('{', nl).indent do
          append_single('scopeName', grammar.scope_name)
          append_single('foldingStartMarker', grammar.folding_start_marker)
          append_single('foldingStopMarker', grammar.folding_stop_marker)
          append_single('firstLineMatch', grammar.first_line_match)
          append_array('patterns', grammar.patterns)
        end

        buffer.append('}')
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def generate_pattern(pattern)
        buffer.append('{', nl).indent do
          append_single('name', pattern.name)
          append_single('match', pattern.match)
          append_single('begin', pattern.begin)
          append_single('end', pattern.end)
          append_single('contentName', pattern.content_name)
          append_single('include', pattern.include)
          append_dictionary('captures', pattern.captures)
          append_dictionary('beginCaptures', pattern.begin_captures)
          append_dictionary('endCaptures', pattern.end_captures)
          append_array('patterns', pattern.patterns)
        end

        buffer.append('}')
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def generate_capture(capture)
        buffer.append('{', nl).indent do
          append_single('name', capture.name)
        end

        buffer.append('}')
      end

      def append_single(key, value)
        buffer.append(key, ' = ', "'", value, "'", ';', nl) if value
      end

      # rubocop:disable Metrics/AbcSize
      def append_array(key, array)
        return if array.blank?

        buffer.append(key, ' = ', '(', nl).indent do
          array.each_with_index do |e, i|
            buffer.append(',', nl) if i != 0
            generate(e)
          end
        end

        buffer.append(nl, ');', nl)
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      def append_dictionary(key, array)
        return if array.blank?

        buffer.append(key, ' = ', '{', nl).indent do
          array.each_with_index do |(element_key, value), i|
            buffer.append(nl) if i != 0
            buffer.append(element_key, ' = ')
            generate(value)
            buffer.append(';')
          end
        end

        buffer.append(nl, '};', nl)
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
