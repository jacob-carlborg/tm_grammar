require 'spec_helper'

describe TmGrammar::Pass::MatchEvaluator do
  let(:grammar) { TmGrammar::Node::Grammar.new('source.foo') }
  let(:pattern) { TmGrammar::Node::Pattern.new }
  let(:capture_number) { 1 }

  let(:evaluator) do
    TmGrammar::Pass::MatchEvaluator.new(grammar, pattern)
  end

  def evaluate(node)
    evaluator.evaluate(node)
  end

  describe 'evaluate' do
    context 'when the node is a string' do
      let(:node) { 'foo' }

      it 'returns the string' do
        evaluate(node).should == node
      end
    end
  end
end
