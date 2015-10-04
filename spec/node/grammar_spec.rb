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

  describe 'patterns' do
    context 'when no patterns are defined' do
      it 'returns an empty array' do
        grammar.patterns.should == []
      end
    end
  end

  describe 'repository' do
    context 'when no patterns in the repository are defined' do
      it 'returns an empty hash' do
        grammar.repository.should == {}
      end
    end
  end

  describe 'file_types' do
    let(:file_types) { %w(foo bar) }

    it 'gets/sets the file types of the grammar' do
      grammar.file_types = file_types
      grammar.file_types.should == file_types
    end
  end

  describe 'folding_start_marker' do
    let(:marker) { /\{\s*$/ }

    it 'gets/sets the folding start marker of the grammar' do
      grammar.folding_start_marker = marker
      grammar.folding_start_marker.should == marker
    end
  end

  describe 'folding_stop_marker' do
    let(:marker) { /^\s*\}/ }

    it 'gets/sets the folding stop marker of the grammar' do
      grammar.folding_stop_marker = marker
      grammar.folding_stop_marker.should == marker
    end
  end

  describe 'first_line_match' do
    let(:match) { %r{#!\/bin\/bash} }

    it 'gets/sets the folding stop marker of the grammar' do
      grammar.first_line_match = match
      grammar.first_line_match.should == match
    end
  end

  describe 'comment' do
    let(:comment) { 'this is a comment' }

    it 'gets/sets the comment of the pattern' do
      grammar.comment = comment
      grammar.comment.should == comment
    end
  end

  describe 'name' do
    let(:name) { 'this is a name' }

    it 'gets/sets the name of the pattern' do
      grammar.name = name
      grammar.name.should == name
    end
  end

  describe 'key_equivalent' do
    let(:key_equivalent) { '^~F' }

    it 'gets/sets the key_equivalent of the pattern' do
      grammar.key_equivalent = key_equivalent
      grammar.key_equivalent.should == key_equivalent
    end
  end

  describe 'uuid' do
    let(:uuid) { '07FD2CA2-93CF-402D-B0F0-FE1F15EC03B7' }

    it 'gets/sets the uuid of the pattern' do
      grammar.uuid = uuid
      grammar.uuid.should == uuid
    end
  end

  describe 'add_pattern' do
    let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }

    it 'adds a pattern to the grammar' do
      grammar.add_pattern(pattern)
      grammar.patterns.should include(pattern)
    end
  end

  describe 'add_rule' do
    let(:name) { 'foo' }
    let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }

    it 'adds a rule to the repository on the grammar' do
      grammar.add_rule(name, pattern)
      grammar.repository.should == { name => pattern }
    end
  end
end
