require 'spec_helper'

describe TmGrammar::Node::Match::Term do
  Term = TmGrammar::Node::Match::Term

  describe 'deconstruct' do
    context 'when a Term node is given' do
      let(:node) { Term.new('value') }

      it 'returns the term value' do
        Term.deconstruct(node).should == ['value']
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { Term.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initialize the object with the given value' do
      Term.new('value').value.should == 'value'
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'returns true' do
        Term.new('value').should == Term.new('value')
      end
    end

    context 'when two nodes are not equal' do
      it 'returns false' do
        Term.new('foo').should_not == Term.new('bar')
      end
    end

    context 'when the other value is not a Term' do
      it 'should not raise an exception' do
        -> { Term.new('value') == 'foo' }.should_not raise_exception
      end

      it 'return false' do
        Term.new('value').should_not == 'foo'
      end
    end
  end

  describe 'to_s' do
    subject { Term.new('value').to_s }
    it { should == 'Term(value)' }
  end
end
