require 'spec_helper'

describe TmGrammar::Node::Pattern do
  let(:pattern) { TmGrammar::Node::Pattern.new }

  describe 'initialize' do
    it 'initializes the new object' do
      pattern.should be_a(TmGrammar::Node::Pattern)
    end

    it 'initializes the captures to an empty array' do
      pattern.captures.should == {}
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

  describe 'add_capture' do
    let(:capture) { TmGrammar::Node::Capture.new }

    it 'adds a capture to the pattern' do
      pattern.add_capture(1, capture)
      pattern.captures.should include(1 => capture)
    end
  end

  describe 'add_pattern' do
    let(:node) { TmGrammar::Node::Pattern.new }

    it 'adds a pattern to the grammar' do
      pattern.add_pattern(node)
      pattern.patterns.should include(node)
    end
  end
end
