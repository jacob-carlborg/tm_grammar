require 'spec_helper'

describe TmGrammar::Node::Match::Group do
  Group = TmGrammar::Node::Match::Group

  describe 'deconstruct' do
    context 'when a Group node is given' do
      let(:node) { Group.new('value') }

      it 'returns the group value' do
        Group.deconstruct(node).should == ['value']
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { Group.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initialize the object with the given value' do
      Group.new('value').node.should == 'value'
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'returns true' do
        Group.new('value').should == Group.new('value')
      end
    end

    context 'when two nodes are not equal' do
      it 'returns false' do
        Group.new('foo').should_not == Group.new('bar')
      end
    end

    context 'when the other value is not a Group' do
      it 'should not raise an exception' do
        -> { Group.new('value') == 'foo' }.should_not raise_exception
      end

      it 'return false' do
        Group.new('value').should_not == 'foo'
      end
    end
  end

  describe 'to_s' do
    subject { Group.new('value').to_s }
    it { should == 'Group(value)' }
  end
end
