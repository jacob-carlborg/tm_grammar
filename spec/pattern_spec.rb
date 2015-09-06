require 'spec_helper'

describe TmGrammar::Pattern do
  let(:name) { 'foo' }
  let(:block) { -> {} }
  let(:pattern) { TmGrammar::Pattern.new(name, block) }
  let(:node) { pattern.node }

  subject { pattern }

  describe 'initialize' do
    it 'creates a new pattern node' do
      node.should be_a(TmGrammar::Node::Pattern)
    end

    it 'initializes the node with the given scope name' do
      node.name.should == name
    end
  end

  describe 'evaluate' do
    it 'evaluates the pattern block' do
      i = 0
      block = -> { i += 1 }
      pattern = TmGrammar::Pattern.new(name, block)
      -> { pattern.evaluate }.should change { i }.by(1)
    end

    it 'evaluates the pattern in a grammar context' do
      context = nil
      block = -> { context = self }
      pattern = TmGrammar::Pattern.new(name, block)
      pattern.evaluate
      context.should be_a(TmGrammar::Pattern::Context)
    end

    it 'returns a pattern node' do
      pattern.evaluate.should be_a(TmGrammar::Node::Pattern)
    end
  end
end
