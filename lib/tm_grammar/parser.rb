module TmGrammar
  class Parser
    def parse_from_file(path)
      content = read_file(path)
      parse(content, path)
    end

    def parse(content, path = nil)
      args = [content]
      args += [path, 1] if path
      Context.new.instance_eval(*args)
    end

    private

    def read_file(path)
      File.read(path)
    end

    class Context
      include TmGrammar::Dsl::Global
    end
  end
end
