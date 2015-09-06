require 'spec_helper'

describe TmGrammar::Pattern do
  let(:block) { -> {} }
  let(:pattern) { TmGrammar::Pattern.new(block) }
  let(:node) { pattern.node }

  subject { pattern }

  describe 'initialize' do
    it 'creates a new pattern node' do
      node.should be_a(TmGrammar::Node::Pattern)
    end
  end

  describe 'evaluate' do
    it 'evaluates the pattern block' do
      i = 0
      block = -> { i += 1 }
      pattern = TmGrammar::Pattern.new(block)
      -> { pattern.evaluate }.should change { i }.by(1)
    end

    it 'evaluates the pattern in a grammar context' do
      context = nil
      block = -> { context = self }
      pattern = TmGrammar::Pattern.new(block)
      pattern.evaluate
      context.should be_a(TmGrammar::Pattern::Context)
    end

    it 'returns a pattern node' do
      pattern.evaluate.should be_a(TmGrammar::Node::Pattern)
    end
  end
end
