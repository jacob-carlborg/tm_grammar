module TmGrammar
  module RSpec
    module Util
      module TempFiles
        module_function

        def files
          @files ||= []
        end

        def clear
          files.each(&:unlink)
        end
      end
    end
  end
end
