require 'spec_helper'

describe TmGrammar::Node::Match::Binary do
  Binary = TmGrammar::Node::Match::Binary

  describe 'deconstruct' do
    context 'when a Binary node is given' do
      let(:node) { Binary.new('left', 'right') }

      it 'returns a tuple of the left and right nodes' do
        Binary.deconstruct(node).should == %w(left right)
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { Binary.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initializes the left node' do
      binary = Binary.new('left', nil)
      binary.left.should == 'left'
    end

    it 'initializes the right node' do
      binary = Binary.new(nil, 'right')
      binary.right.should == 'right'
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'compares the two nodes successfully' do
        Binary.new('left', 'right').should == Binary.new('left', 'right')
      end
    end

    context 'when two nodes are not equal' do
      it 'fails to compare the two nodes' do
        Binary.new('left', 'right').should_not == Binary.new('left', 'left')
      end
    end
  end
end
