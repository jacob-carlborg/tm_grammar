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

  describe 'match' do
    let(:match) { /foo/ }

    it 'gets/sets the match of the pattern' do
      grammar.match = match
      grammar.match.should == match
    end
  end

  describe 'begin' do
    let(:match) { /foo/ }

    it 'gets/sets the being match of the pattern' do
      grammar.begin = match
      grammar.begin.should == match
    end
  end

  describe 'end' do
    let(:match) { /foo/ }

    it 'gets/sets the end match of the pattern' do
      grammar.end = match
      grammar.end.should == match
    end
  end

  describe 'content_name' do
    let(:name) { 'foo' }

    it 'gets/sets the content name of the pattern' do
      grammar.content_name = name
      grammar.content_name.should == name
    end
  end
end
