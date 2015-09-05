require 'spec_helper'

describe TmGrammar::Node::Pattern do
  let(:name) { 'keyword.control.foo' }
  let(:grammar) { TmGrammar::Node::Pattern.new(name) }

  subject { grammar }

  describe 'initialize' do
    it 'initializes the object with the given name and block' do
      grammar.name.should == name
    end
  end

  describe 'name' do
    it 'returns the name of the pattern' do
      grammar.name.should == name
    end
  end
end
