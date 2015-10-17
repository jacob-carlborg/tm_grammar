module TmGrammar
  module Generator
    class TextMateGrammar < Base
      using PatternMatch
      include TmGrammar::Node
      include TmGrammar::Util

      def initialize(options = nil)
        super
        indentation = self.options.indent_text * self.options.indent
        @buffer = TmGrammar::Util::Buffer.new(indentation)
      end

      # rubocop:disable Metrics/AbcSize
      def generate(node)
        match(node) do
          with(TmGrammar::Node::Grammar) { generate_grammar(node) }
          with(TmGrammar::Node::Pattern) { generate_pattern(node) }
          with(TmGrammar::Node::Capture) { generate_capture(node) }
          with(String) { generate_string(node) }
          with(Regexp) { generate_regexp(node) }
          with(_) { raise "Unhandled node type #{node.class.name}" }
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      attr_reader :buffer

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def generate_grammar(grammar)
        buffer.append('{', nl).indent do
          append_single('scopeName', grammar.scope_name)

          if options.rules_to_generate.present?
            append_array('patterns', extract_patterns(grammar.repository))
            append_dictionary('repository', grammar.repository)
          else
            append_single('foldingStartMarker', grammar.folding_start_marker)
            append_single('foldingStopMarker', grammar.folding_stop_marker)
            append_single('firstLineMatch', grammar.first_line_match)
            append_single('comment', grammar.comment)
            append_array('patterns', grammar.patterns)
            append_dictionary('repository', grammar.repository)
          end
        end

        buffer.append('}')
      end
      # rubocop:enable Metrics/MethodLength
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
          append_single('comment', pattern.comment)
          buffer.append('disabled = ', 1, ';', nl) if pattern.disabled
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
          append_array('patterns', capture.patterns)
        end

        buffer.append('}')
      end

      def generate_string(string)
        quote = contains_single_quote?(string) ? '"' : "'"
        quote + string + quote
      end

      def generate_regexp(regexp)
        "'" + regexp.source + "'"
      end

      def append_single(key, value)
        return unless value
        value = generate(value)
        buffer.append(key, ' = ', value, ';', nl)
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

      def contains_single_quote?(value)
        value.respond_to?(:include?) && value.include?("'")
      end
    end
  end
end
