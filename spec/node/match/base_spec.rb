require 'spec_helper'

describe TmGrammar::Node::Match::Base do
  And = TmGrammar::Node::Match::And
  Base = TmGrammar::Node::Match::Base
  Or = TmGrammar::Node::Match::Or

  describe 'deconstruct' do
    context 'when a Base node is given' do
      it 'returns nil' do
        Base.deconstruct(Base.new).should be_nil
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { Base.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe '+' do
    it 'constructs an And node' do
      (subject + 'foo').should == And.new(subject, 'foo')
    end
  end

  describe '|' do
    it 'constructs an Or node' do
      (subject | 'foo').should == Or.new(subject, 'foo')
    end
  end
end
