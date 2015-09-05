require 'spec_helper'

describe TmGrammar::Node::Grammar do
  let(:scope_name) { 'source.foo' }
  let(:grammar) { TmGrammar::Node::Grammar.new(scope_name) }
  subject { grammar }

  describe 'initialize' do
    it 'initializes the object with the given scope name' do
      grammar.scope_name.should == scope_name
    end
  end

  describe 'scope_name' do
    it 'returns the scope name of the grammar' do
      grammar.scope_name.should == scope_name
    end
  end
end
