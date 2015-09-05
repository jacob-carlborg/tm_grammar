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
end
