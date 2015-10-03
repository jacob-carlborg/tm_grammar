require 'spec_helper'

describe TmGrammar::Pass::MatchEvaluator do
  Match = TmGrammar::Node::Match

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

    context 'when the node is an And node' do
      let(:left) { 'left' }
      let(:right) { 'right' }
      let(:node) { Match::And.new(left, right) }

      it 'concatenates the left and right nodes' do
        evaluate(node).should == left + right
      end
    end

    context 'when the node is an Or node' do
      let(:left) { 'left' }
      let(:right) { 'right' }
      let(:node) { Match::Or.new(left, right) }

      it 'ors the left and right nodes' do
        evaluate(node).should == "(?:#{left}|#{right})"
      end
    end
  end
end
