require 'spec_helper'

describe TmGrammar::Grammar do
  let(:scope_name) { 'source.foo' }
  let(:block) { -> {} }
  let(:grammar) { TmGrammar::Grammar.new(scope_name, &block) }
  let(:node) { grammar.node }

  subject { grammar }

  describe 'initialize' do
    it 'creates a new grammar node' do
      grammar.node.should be_a(TmGrammar::Node::Grammar)
    end

    it 'initializes the node with the given scope name' do
      grammar.node.scope_name.should == scope_name
    end
  end

  describe 'evaluate' do
    it 'evaluates the grammar block' do
      i = 0
      block = -> { i += 1 }
      grammar = TmGrammar::Grammar.new(scope_name, &block)
      -> { grammar.evaluate }.should change { i }.by(1)
    end

    it 'evaluates the grammar in a grammar context' do
      context = nil
      block = -> { context = self }
      grammar = TmGrammar::Grammar.new(scope_name, &block)
      grammar.evaluate
      context.should be_a(TmGrammar::Grammar::Context)
    end
  end

  describe 'define_pattern' do
    let(:name) { 'foo' }
    let(:block) { -> {} }

    it 'defines a new pattern' do
      pattern = TmGrammar::Node::Pattern
      node.should_receive(:add_pattern).with(an_instance_of(pattern))
        .and_call_original

      grammar.define_pattern(name, block)
    end
  end

  describe 'define_rule' do
    let(:name) { 'foo' }
    let(:blcok) { -> {} }

    it 'defines a rule in the repository' do
      pattern = TmGrammar::Node::Pattern
      node.should_receive(:add_rule)
        .with(a_kind_of(String), an_instance_of(pattern)).and_call_original

      grammar.define_rule(name, block)
    end
  end
end
