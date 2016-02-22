require 'pry'
require 'rspec/its'

require 'tm_grammar'
require 'tm_grammar/rspec'

RSpec.configure do |config|
  config.order = :random
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
end
