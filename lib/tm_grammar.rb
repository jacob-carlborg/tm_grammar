require 'stringio'

require 'active_support/core_ext/object/blank'
require 'pattern-match'

require 'tm_grammar/version'

module TmGrammar
  autoload :Capture, 'tm_grammar/capture'
  autoload :Grammar, 'tm_grammar/grammar'
  autoload :Parser, 'tm_grammar/parser'
  autoload :Pattern, 'tm_grammar/pattern'

  module Dsl
    autoload :Capture, 'tm_grammar/dsl'
    autoload :Global, 'tm_grammar/dsl'
    autoload :Grammar, 'tm_grammar/dsl'
    autoload :Pattern, 'tm_grammar/dsl'
  end

  module Generator
    autoload :TextMateGrammar, 'tm_grammar/generator/text_mate_grammar'
  end

  module Node
    autoload :Capture, 'tm_grammar/node/capture'
    autoload :Grammar, 'tm_grammar/node/grammar'
    autoload :Pattern, 'tm_grammar/node/pattern'
  end

  module Util
    autoload :Buffer, 'tm_grammar/util/buffer'
  end
end
