require 'active_support/core_ext/module/attribute_accessors'

require 'tm_grammar/rspec/matchers/be_parsed_as'
require 'tm_grammar/rspec/util/temp_files'

RSpec.configure do |config|
  config.include TmGrammar::RSpec::Matchers

  config.after :example do
    TmGrammar::RSpec::Util::TempFiles.clear
  end
end
