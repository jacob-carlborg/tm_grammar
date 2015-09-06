require 'spec_helper'

describe TmGrammar::Node::Pattern do
  let(:pattern) { TmGrammar::Node::Pattern.new }

  describe 'initialize' do
    it 'initializes the new object' do
      pattern.should be_a(TmGrammar::Node::Pattern)
    end
  end

  describe 'name' do
    let(:name) { 'keyword.control.foo' }

    it 'gets/sets the name of the pattern' do
      pattern.name = name
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
