require 'stringio'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/object/blank'

require 'nokogiri'
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
    autoload :Base, 'tm_grammar/generator/base'
    autoload :TextMateGrammar, 'tm_grammar/generator/text_mate_grammar'
    autoload :TmLanguageXml, 'tm_grammar/generator/tm_language_xml'
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
