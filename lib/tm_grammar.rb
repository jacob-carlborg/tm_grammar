require 'stringio'

require 'tm_grammar/version'

module TmGrammar
  autoload :Capture, 'tm_grammar/capture'
  autoload :Grammar, 'tm_grammar/grammar'
  autoload :Pattern, 'tm_grammar/pattern'

  module Dsl
    autoload :Grammar, 'tm_grammar/dsl'
    autoload :Pattern, 'tm_grammar/dsl'
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
