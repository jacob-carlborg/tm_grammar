require 'spec_helper'

describe TmGrammar::Node::Pattern do
  let(:name) { 'keyword.control.foo' }
  let(:pattern) { TmGrammar::Node::Pattern.new(name) }

  describe 'initialize' do
    it 'initializes the object with the given name and block' do
      pattern.name.should == name
    end
  end

  describe 'name' do
    it 'returns the name of the pattern' do
      pattern.name.should == name
    end
  end

  describe 'match' do
    let(:match) { /foo/ }

    it 'gets/sets the match of the pattern' do
      pattern.match = match
      pattern.match.should == match
    end
  end

  describe 'begin' do
    let(:match) { /foo/ }

    it 'gets/sets the being match of the pattern' do
      pattern.begin = match
      pattern.begin.should == match
    end
  end

  describe 'end' do
    let(:match) { /foo/ }

    it 'gets/sets the end match of the pattern' do
      pattern.end = match
      pattern.end.should == match
    end
  end

  describe 'content_name' do
    let(:name) { 'foo' }

    it 'gets/sets the content name of the pattern' do
      pattern.content_name = name
      pattern.content_name.should == name
    end
  end
end
