module TmGrammar
  module RSpec
    module Matchers
      def be_parsed_as(scope)
        BeParsedAs.new(scope)
      end

      # rubocop:disable Metrics/ClassLength
      class BeParsedAs
        cattr_accessor :grammar

        def initialize(scope)
          @scope = scope
        end

        def in_code(code)
          tap { @code = code }
        end

        def with_rule(rule)
          tap { @rule = rule }
        end

        def description
          %(be parsed as "#{scope}" in code "#{code}")
        end

        def failure_message
          %(expected: "#{code_extract}" to be parsed as "#{scope}" in code ) +
            %("#{code}"\n) +
            %(     got: "#{parsed_code_extract}" parsed as ) +
            %("#{parsed_scope}")
        end

        def failure_message_when_negated
          # rubocop:disable Metrics/LineLength
          %(expected: "#{code_extract}" not to be parsed as "#{scope}" in code ) +
            %("#{code}") +
            %(\n     got: "#{parsed_code_extract}" parsed as ) +
            %("#{parsed_scope}")
          # rubocop:enable Metrics/LineLength
        end

        def matches?(code_extract)
          @code_extract = code_extract
          write_code
          generate_grammar
          result = match_grammar
          result = filter_result(result)
          @parsed_scope, @parsed_code_extract = extract_result(result)
          result_matches?(code_extract)
        end

        private

        attr_reader :scope
        attr_reader :code
        attr_reader :rule
        attr_reader :parsed_scope
        attr_reader :parsed_code_extract

        attr_accessor :code_extract

        def grammar_path
          @grammar_path ||= create_temp_file('grammar')
        end

        def code_path
          @code_path ||= create_temp_file('code')
        end

        def generate_grammar
          `tm_grammar -r #{rule} #{self.class.grammar} > #{grammar_path}`
        end

        def match_grammar
          `gtm < "#{code_path}" "#{grammar_path}" 2>&1`
        end

        def write_code
          File.write(code_path, code)
        end

        def create_temp_file(prefix)
          file = Tempfile.new(prefix)
          TmGrammar::RSpec::Util::TempFiles.files << file
          file.path
        end

        def filter_result(result)
          lines = result.split("\n")
          filtered_lines = lines.reject { |e| lines_to_filter.include?(e) }
          result = filtered_lines.join("\n")
          "<#{root_name}>#{result}</#{root_name}>"
        end

        def extract_result(result)
          root = Nokogiri::XML(result).root
          node, content_node = extract_result_impl(root)
          node ||= root
          content_node ||= root

          [node.name, content_node.content]
        end

        def extract_result_impl(node)
          if node.name == scope
            content_node = extract_content(node)
            return node, content_node if content_node
          end

          node.children.each do |c|
            node_tuple = extract_result_impl(c)
            return node_tuple if node_tuple
          end

          nil
        end

        def extract_content(node)
          return node if node.content == code_extract

          node.children.each do |c|
            n = extract_content(c)
            return n if n
          end

          nil
        end

        def result_matches?(code_extract)
          parsed_scope == scope && parsed_code_extract == code_extract
        end

        def lines_to_filter
          # rubocop:disable Metrics/LineLength
          @lines_to_filter ||= [
            'grammar_for_scope: unable to find a grammar for ‘text.html.javadoc’',
            '*** couldn’t resolve text.html.javadoc',
            '*** couldn’t resolve #regular_expressions',
            'failed to resolve text.html.javadoc',
            'grammar_for_scope: unable to find a grammar for ‘source.regexp.python’',
            '*** couldn’t resolve source.regexp.python'
          ].freeze
          # rubocop:enable Metrics/LineLength
        end

        def root_name
          @root_name ||= 'unscoped'
        end
      end
      # rubocop:enable Metrics/ClassLength
    end
  end
end
