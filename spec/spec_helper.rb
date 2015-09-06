require 'tm_grammar'

RSpec.configure do |config|
  config.order = :random
  config.expect_with(:rspec) { |c| c.syntax = :should }
  config.mock_with(:rspec) { |c| c.syntax = :should }
end
