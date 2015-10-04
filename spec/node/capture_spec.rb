require 'spec_helper'

describe TmGrammar::Node::Capture do
  let(:capture) { TmGrammar::Node::Capture.new }

  describe 'initialize' do
    it 'initializes the object ' do
      capture.should be_a(TmGrammar::Node::Capture)
    end
  end

  describe 'patterns' do
    context 'when no patterns are defined' do
      it 'returns an empty array' do
        capture.patterns.should == []
      end
    end
  end

  describe 'add_pattern' do
    let(:scope_name) { 'source.foo' }
    let(:grammar) { TmGrammar::Node::Grammar.new(scope_name) }
    let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }

    it 'adds a pattern to the grammar' do
      capture.add_pattern(pattern)
      capture.patterns.should include(pattern)
    end
  end
end
