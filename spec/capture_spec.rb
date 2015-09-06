require 'spec_helper'

describe TmGrammar::Capture do
  let(:number) { 1 }
  let(:name) { 'foo' }
  let(:block) { -> {} }
  let(:capture) { TmGrammar::Capture.new(number, name, block) }
  let(:node) { capture.node }

  subject { pattern }

  describe 'initialize' do
    it 'creates a new capture node' do
      node.should be_a(TmGrammar::Node::Capture)
    end

    it 'initializes the node with the given number' do
      node.number.should == number
    end

    it 'initializes the node with the given name' do
      node.name.should == name
    end
  end
end
