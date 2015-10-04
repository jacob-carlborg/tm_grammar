require 'spec_helper'

describe TmGrammar::Match do
  let(:grammar) { TmGrammar::Node::Grammar.new('source.foo') }
  let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }
  let(:block) { -> {} }
  let(:match) { TmGrammar::Match.new(pattern, block) }

  describe 'initialize' do
    it 'initializes the object with the given pattern' do
      match.send(:pattern).should == pattern
    end

    it 'initializes the object with the given block' do
      match.send(:block).should == block
    end
  end

  describe '==' do
    context 'when both the pattern and the block is equal' do
      it 'the two objects are equal' do
        match.should == TmGrammar::Match.new(pattern, block)
      end
    end

    context 'when the patterns are not equal' do
      let(:second_grammar) { TmGrammar::Node::Grammar.new('source.foo2') }
      let(:second_pattern) { TmGrammar::Node::Pattern.new(second_grammar) }

      it 'the two objects are not equal' do
        match.should_not == TmGrammar::Match.new(second_pattern, block)
      end
    end

    context 'when the blocks are not equal' do
      it 'the two objects are not equal' do
        match.should_not == TmGrammar::Match.new(pattern, -> {})
      end
    end
  end

  describe 'evaluate' do
    let(:match_block) { -> { Object.new } }

    before :each do
      TmGrammar::Pass::MatchEvaluator.any_instance
        .stub(:evaluate) { match_block.call }
    end

    it 'evaluates the match block' do
      i = 0
      match = TmGrammar::Match.new(pattern, -> { i += 1 })
      -> { match.evaluate }.should change { i }.by(1)
    end

    it 'evaluates the match in a match context' do
      context = nil
      match = TmGrammar::Match.new(pattern, -> { context = self })
      match.evaluate
      context.should be_a(TmGrammar::Match::Context)
    end

    it 'only evaluates the match once' do
      match = TmGrammar::Match.new(pattern, match_block)
      result1 = match.evaluate
      result2 = match.evaluate
      result1.should equal(result2)
    end
  end
end
