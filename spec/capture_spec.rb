require 'spec_helper'

describe TmGrammar::Capture do
  let(:grammar) { TmGrammar::Grammar.new('foo', -> {}).node }
  let(:name) { 'foo' }
  let(:block) { -> {} }
  let(:capture) { TmGrammar::Capture.new(grammar, name, block) }
  let(:node) { capture.node }

  subject { pattern }

  describe 'initialize' do
    it 'creates a new capture node' do
      node.should be_a(TmGrammar::Node::Capture)
    end

    it 'initializes the node with the given name' do
      node.name.should == name
    end
  end

  describe 'evaluate' do
    it 'evaluates the capture block' do
      i = 0
      block = -> { i += 1 }
      capture = TmGrammar::Capture.new(grammar, name, block)
      -> { capture.evaluate }.should change { i }.by(1)
    end

    it 'evaluates the capture in a capture context' do
      context = nil
      block = -> { context = self }
      pattern = TmGrammar::Capture.new(grammar, name, block)
      pattern.evaluate
      context.should be_a(TmGrammar::Capture::Context)
    end

    it 'returns a capture node' do
      capture.evaluate.should be_a(TmGrammar::Node::Capture)
    end
  end

  describe 'define_pattern' do
    let(:name) { 'foo' }
    let(:block) { -> {} }

    it 'defines a new pattern' do
      pattern = TmGrammar::Node::Pattern
      node.should_receive(:add_pattern).with(an_instance_of(pattern))
        .and_call_original

      capture.define_pattern(name, block)
    end
  end
end
