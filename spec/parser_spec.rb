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

  describe 'handle_pattern' do
    let(:pattern) { TmGrammar::Node::Pattern.new(nil) }
    let(:match_result) { :result }

    before :each do
      parser.stub(:resolve_matches).and_return(match_result)
    end

    def handle_pattern
      subject.send(:handle_pattern, pattern)
    end

    it 'returns a new pattern' do
      handle_pattern.should_not equal(pattern)
    end

    it 'updates the match' do
      handle_pattern.match.should == match_result
    end

    it 'updates the begin match' do
      handle_pattern.begin.should == match_result
    end

    it 'updates the end match' do
      handle_pattern.end.should == match_result
    end
  end
end
