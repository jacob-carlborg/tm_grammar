require 'spec_helper'

describe TmGrammar::Node::Match::Capture do
  Capture = TmGrammar::Node::Match::Capture

  describe 'deconstruct' do
    context 'when a Capture node is given' do
      let(:node) { Capture.new('value') }

      it 'returns the capture value' do
        Capture.deconstruct(node).should == ['value']
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { Capture.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initialize the object with the given value' do
      Capture.new('value').node.should == 'value'
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'returns true' do
        Capture.new('value').should == Capture.new('value')
      end
    end

    context 'when two nodes are not equal' do
      it 'returns false' do
        Capture.new('foo').should_not == Capture.new('bar')
      end
    end

    context 'when the other value is not a Capture' do
      it 'should not raise an exception' do
        -> { Capture.new('value') == 'foo' }.should_not raise_exception
      end

      it 'return false' do
        Capture.new('value').should_not == 'foo'
      end
    end
  end

  describe 'to_s' do
    subject { Capture.new('value').to_s }
    it { should == 'Capture(value)' }
  end
end
