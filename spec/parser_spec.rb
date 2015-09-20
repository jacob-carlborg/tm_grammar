require 'spec_helper'

describe TmGrammar::Parser do
  let(:parser) { subject }
  let(:scope_name) { 'source.foo' }

  let(:tm_grammar) do
    <<-tmg
grammar '#{scope_name}' do
end
tmg
  end

  describe 'initialize' do
    it 'initializes the object' do
      parser.should be_a(TmGrammar::Parser)
    end
  end

  describe 'parse' do
    it 'evaluates tm grammar' do
      ::RSpec::Mocks.space.any_instance_proxy_for(TmGrammar::Dsl::Global)
        .should_receive(:grammar).with(scope_name)

      parser.parse(tm_grammar)
    end

    it 'returns a grammar node' do
      parser.parse(tm_grammar).should be_a(TmGrammar::Node::Grammar)
    end
  end

  describe 'parse_from_file' do
    let(:path) { 'foo' }

    it 'evaluate the tm grammar in the file' do
      parser.stub(:read_file).and_return(tm_grammar)
      parser.should_receive(:parse).with(tm_grammar, path).and_call_original

      parser.parse_from_file(path)
    end
  end
end
