require 'spec_helper'

describe TmGrammar::Node::Match::WordBoundary do
  WordBoundary = TmGrammar::Node::Match::WordBoundary

  describe 'deconstruct' do
    context 'when a WordBoundary node is given' do
      let(:node) { WordBoundary.new('value') }

      it 'returns the term value' do
        WordBoundary.deconstruct(node).should == ['value']
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { WordBoundary.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initialize the object with the given value' do
      WordBoundary.new('value').node.should == 'value'
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'returns true' do
        WordBoundary.new('value').should == WordBoundary.new('value')
      end
    end

    context 'when two nodes are not equal' do
      it 'returns false' do
        WordBoundary.new('foo').should_not == WordBoundary.new('bar')
      end
    end

    context 'when the other value is not a WordBoundary' do
      it 'should not raise an exception' do
        -> { WordBoundary.new('value') == 'foo' }.should_not raise_exception
      end

      it 'return false' do
        WordBoundary.new('value').should_not == 'foo'
      end
    end
  end

  describe 'to_s' do
    subject { WordBoundary.new('value').to_s }
    it { should == 'WordBoundary(value)' }
  end
end
