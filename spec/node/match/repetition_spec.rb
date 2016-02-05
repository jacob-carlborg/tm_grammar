require 'spec_helper'

describe TmGrammar::Node::Match::Repetition do
  Repetition = TmGrammar::Node::Match::Repetition

  let(:inner_node) { 'value' }
  let(:type) { Repetition::TYPE_OPTIONAL }
  let(:node) { Repetition.new(inner_node, type) }

  subject { node }

  describe 'deconstruct' do
    context 'when a Repetition node is given' do
      it 'returns the repetition value' do
        Repetition.deconstruct(node).should == [inner_node, type]
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { Repetition.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initialize the object with the given value' do
      node.node.should == inner_node
    end

    it 'initialize the object with the given type' do
      node.type.should == type
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'returns true' do
        node.should == node
      end
    end

    context 'when two nodes are not equal' do
      it 'returns false' do
        node.should_not == Repetition.new(inner_node + 'foo', type + 1)
      end
    end

    context 'when the other value is not a Repetition' do
      it 'should not raise an exception' do
        -> { node == 'foo' }.should_not raise_exception
      end

      it 'return false' do
        node.should_not == 'foo'
      end
    end

    context 'when the inner nodes are equal but not the types' do
      it 'returns false' do
        type = Repetition::TYPE_ONE_OR_MORE
        node.should_not == Repetition.new(inner_node, type)
      end
    end

    context 'when the types are equal but not the inner nodes' do
      it 'returns false' do
        node.should_not == Repetition.new(inner_node + 'foo', type)
      end
    end
  end

  describe 'optional?' do
    context 'when the repetition type is an optional' do
      its(:optional?) { should == true }
    end

    context 'when the repetition type is not an optional' do
      let(:type) { Repetition::TYPE_ZERO_OR_MORE }
      its(:optional?) { should == false }
    end
  end

  context 'when the type is TYPE_OPTIONAL' do
    let(:type) { Repetition::TYPE_OPTIONAL }
    its(:to_s) { should == 'Repetition(value?)' }
  end

  context 'when the type is TYPE_ZERO_OR_MORE' do
    let(:type) { Repetition::TYPE_ZERO_OR_MORE }
    its(:to_s) { should == 'Repetition(value*)' }
  end

  context 'when the type is TYPE_ONE_OR_MORE' do
    let(:type) { Repetition::TYPE_ONE_OR_MORE }
    its(:to_s) { should == 'Repetition(value+)' }
  end
end
