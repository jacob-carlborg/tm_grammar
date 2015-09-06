require 'tm_grammar/version'

module TmGrammar
  autoload :Grammar, 'tm_grammar/grammar'

  module Dsl
    autoload :Grammar, 'tm_grammar/dsl'
  end

  module Node
    autoload :Grammar, 'tm_grammar/node/grammar'
    autoload :Pattern, 'tm_grammar/node/pattern'
  end
end
