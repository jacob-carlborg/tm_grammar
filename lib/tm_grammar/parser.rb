module TmGrammar
  class Parser
    using PatternMatch

    def parse_from_file(path)
      content = read_file(path)
      parse(content, path)
    end

    def parse(content, path = nil)
      args = [content]
      args += [path, 1] if path
      grammar = Context.new.instance_eval(*args)
      resolve_matches(grammar)
    end

    private

    def read_file(path)
      File.read(path)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def resolve_matches(node)
      grammar = nil
      pattern = nil

      match(node) do
        with(TmGrammar::Node::Grammar) { grammar = handle_grammar(node) }
        with(TmGrammar::Node::Pattern) { pattern = handle_pattern(node) }
        with(TmGrammar::Match) { node.evaluate }

        with(Array) { node.map { |e| resolve_matches(e) } }
        with(Hash) { node.transform_values { |e| resolve_matches(e) } }

        with(nil) { nil }
        with(_) { node.dup }
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def handle_grammar(grammar)
      grammar.dup.tap do |g|
        g.patterns = resolve_matches(g.patterns)
        g.repository = resolve_matches(g.repository)
      end
    end

    def handle_pattern(pattern)
      pattern.dup.tap do |p|
        p.match = resolve_matches(p.match)
        p.begin = resolve_matches(p.begin)
        p.end = resolve_matches(p.end)
      end
    end

    class Context
      include TmGrammar::Dsl::Global
    end
  end
end
