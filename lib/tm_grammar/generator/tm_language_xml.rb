module TmGrammar
  module Generator
    # rubocop:disable Metrics/ClassLength
    class TmLanguageXml < Base
      using PatternMatch

      include TmGrammar::Util

      def initialize(options = nil)
        super
        @plist = Nokogiri::XML::Builder.new(encoding: 'UTF-8') { |_| }
      end

      def generate(node)
        _generate(node)
        xml = plist.doc.root.to_xml(
          indent_text: options.indent_text,
          indent: options.indent
        )

        PLIST_HEADER + xml + PLIST_FOOTER
      end

      private

      # rubocop:disable Metrics/LineLength
      PLIST_HEADER = <<-xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
xml
      # rubocop:enable Metrics/LineLength

      PLIST_FOOTER = "\n</plist>\n"

      private_constant :PLIST_HEADER
      private_constant :PLIST_FOOTER

      attr_reader :plist

      # rubocop:disable Metrics/AbcSize
      def _generate(node)
        match(node) do
          with(TmGrammar::Node::Grammar) { generate_grammar(node) }
          with(TmGrammar::Node::Pattern) { generate_pattern(node) }
          with(TmGrammar::Node::Capture) { generate_capture(node) }
          with(String) { generate_string(node) }
          with(Regexp) { generate_regexp(node) }
          with(Integer) { generate_integer(node) }
          with(_) { raise "Unhandled node type #{node.class.name}" }
        end
      end
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def generate_grammar(grammar)
        plist.dict do
          if options.rules_to_generate.present?
            append_array('patterns', extract_patterns(grammar.repository))
          else
            append_single('comment', grammar.comment)
            append_array('fileTypes', grammar.file_types)
            append_single('firstLineMatch', grammar.first_line_match)
            append_single('keyEquivalent', grammar.key_equivalent)
            append_single('name', grammar.name)
            append_array('patterns', grammar.patterns)
            append_dictionary('repository', grammar.repository)
            append_single('foldingStartMarker', grammar.folding_start_marker)
            append_single('foldingStopMarker', grammar.folding_stop_marker)
          end

          append_single('scopeName', grammar.scope_name)
          append_single('uuid', grammar.uuid)
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def generate_pattern(pattern)
        plist.dict do
          append_single('begin', pattern.begin)
          append_dictionary('beginCaptures', pattern.begin_captures)
          append_dictionary('captures', pattern.captures)
          append_single('comment', pattern.comment)
          append_single('contentName', pattern.content_name)
          append_single('disabled', 1) if pattern.disabled
          append_single('end', pattern.end)
          append_dictionary('endCaptures', pattern.end_captures)
          append_single('include', pattern.include)
          append_single('match', pattern.match)
          append_single('name', pattern.name)
          append_array('patterns', pattern.patterns)
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize

      def generate_capture(capture)
        plist.dict do
          append_single('name', capture.name)
          append_array('patterns', capture.patterns)
        end
      end

      def generate_string(string)
        plist.string(string)
      end

      def generate_regexp(regexp)
        plist.string(regexp.source)
      end

      def generate_integer(integer)
        plist.integer(integer)
      end

      def append_single(key, value)
        return unless value
        plist.key(key)
        _generate(value)
      end

      def append_array(key, array)
        return buffer if array.blank?

        plist.key(key)
        plist.array do
          array.each { |e| _generate(e) }
        end
      end

      def append_dictionary(key, hash)
        return buffer if hash.blank?
        hash = hash.transform_keys(&:to_s).sort

        plist.key(key)
        plist.dict do
          hash.each do |element_key, value|
            plist.key(element_key)
            _generate(value)
          end
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
