require 'stringio'

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/transform_values'
require 'active_support/core_ext/object/blank'

require 'nokogiri'
require 'pattern-match'

require 'tm_grammar/version'

module TmGrammar
  autoload :Application, 'tm_grammar/application'
  autoload :Capture, 'tm_grammar/capture'
  autoload :Grammar, 'tm_grammar/grammar'
  autoload :Match, 'tm_grammar/match'
  autoload :Parser, 'tm_grammar/parser'
  autoload :Pattern, 'tm_grammar/pattern'

  module Dsl
    autoload :Capture, 'tm_grammar/dsl'
    autoload :Global, 'tm_grammar/dsl'
    autoload :Grammar, 'tm_grammar/dsl'
    autoload :Match, 'tm_grammar/dsl'
    autoload :Pattern, 'tm_grammar/dsl'
  end

  module Generator
    autoload :Base, 'tm_grammar/generator/base'
    autoload :TextMateGrammar, 'tm_grammar/generator/text_mate_grammar'
    autoload :TmLanguageXml, 'tm_grammar/generator/tm_language_xml'
  end

  module Node
    autoload :Capture, 'tm_grammar/node/capture'
    autoload :Grammar, 'tm_grammar/node/grammar'
    autoload :Pattern, 'tm_grammar/node/pattern'

    class Match
      autoload :And, 'tm_grammar/node/match/and'
      autoload :Base, 'tm_grammar/node/match/base'
      autoload :Binary, 'tm_grammar/node/match/binary'
      autoload :Capture, 'tm_grammar/node/match/capture'
      autoload :Group, 'tm_grammar/node/match/group'
      autoload :Or, 'tm_grammar/node/match/or'
      autoload :Repetition, 'tm_grammar/node/match/repetition'
      autoload :RuleReference, 'tm_grammar/node/match/rule_reference'
      autoload :Term, 'tm_grammar/node/match/term'
    end
  end

  module Pass
    autoload :MatchEvaluator, 'tm_grammar/pass/match_evaluator'
  end

  module Util
    autoload :Buffer, 'tm_grammar/util/buffer'
    autoload :Util, 'tm_grammar/util/util'
  end
end
