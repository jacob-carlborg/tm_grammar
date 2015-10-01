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

    context 'when the node is a regular expression' do
      let(:source) { 'foo' }
      let(:node) { Regexp.new(source) }

      it 'returns the source of the regular expression' do
        evaluate(node).should == source
      end
    end
  end
end
