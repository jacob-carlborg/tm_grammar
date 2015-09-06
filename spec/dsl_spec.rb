require 'spec_helper'

describe TmGrammar::Dsl do
  describe TmGrammar::Dsl::Grammar do
    let(:grammar) { double(:grammar) }
    let(:node) { double(:node) }
    subject { Class.new { include TmGrammar::Dsl::Grammar }.new(grammar, node) }

    describe 'initialize' do
      it 'initialize the receiver with the given grammar and node' do
        subject.node.should == node
        subject.grammar.should == grammar
      end
    end

    describe 'file_types' do
      let(:file_types) { %w(foo bar) }

      it 'sets the file types on the grammar node' do
        node.should_receive(:file_types=).with(file_types)
        subject.should_receive(:node).and_return(node)

        subject.file_types(file_types)
      end
    end

    describe 'folding_start_marker' do
      let(:marker) { /\{\s*$/ }

      it 'sets the folding start marker on the grammar node' do
        node.should_receive(:folding_start_marker=).with(marker)
        subject.should_receive(:node).and_return(node)

        subject.folding_start_marker(marker)
      end
    end

    describe 'folding_start_marker' do
      let(:marker) { /^\s*\}/ }

      it 'sets the folding stop marker on the grammar node' do
        node.should_receive(:folding_stop_marker=).with(marker)
        subject.should_receive(:node).and_return(node)

        subject.folding_stop_marker(marker)
      end
    end

    describe 'pattern' do
      let(:name) { 'foo' }
      let(:block) { -> {} }

      it 'defines a pattern on the grammar' do
        grammar.should_receive(:define_pattern).with(name, block)
        subject.should_receive(:grammar).and_return(grammar)

        subject.pattern(name, &block)
      end

      context 'when no name is given' do
        it 'defines a pattern on the grammar' do
          grammar.should_receive(:define_pattern).with(nil, block)

          subject.pattern(&block)
        end
      end
    end
  end

  describe TmGrammar::Dsl::Pattern do
    let(:pattern_object) { double(:pattern_object) }
    let(:node) { double(:node) }

    subject do
      Class.new { include TmGrammar::Dsl::Pattern }.new(pattern_object, node)
    end

    describe 'initialize' do
      it 'initialize the receiver with the given pattern object and node' do
        subject.node.should == node
        subject.pattern_object.should == pattern_object
      end
    end

    describe 'name' do
      let(:name) { 'foo' }

      it 'sets the name on the pattern node' do
        node.should_receive(:name=).with(name)
        subject.name(name)
      end
    end

    describe 'match' do
      let(:match) { /foo/ }

      it 'sets the match on the pattern node' do
        node.should_receive(:match=).with(match)
        subject.match(match)
      end
    end

    describe 'begin' do
      let(:match) { /foo/ }

      it 'sets the begin match on the pattern node' do
        node.should_receive(:begin=).with(match)
        subject.begin(match)
      end
    end

    describe 'end' do
      let(:match) { /foo/ }

      it 'sets the end match on the pattern node' do
        node.should_receive(:end=).with(match)
        subject.end(match)
      end
    end

    describe 'content_name' do
      let(:name) { 'foo' }

      it 'sets the content name on the pattern node' do
        node.should_receive(:content_name=).with(name)
        subject.content_name(name)
      end
    end

    describe 'capture' do
      let(:key) { 1 }
      let(:name) { 'foo' }
      let(:block) { -> {} }

      context 'when a name is given' do
        it 'defines a capture for the pattern' do
          pattern_object.should_receive(:define_capture).with(key, name, nil)
          subject.capture(key, name)
        end
      end

      context 'when a block is given' do
        it 'defines a capture for the pattern' do
          args = [key, nil, block]
          pattern_object.should_receive(:define_capture).with(*args)
          subject.capture(key, &block)
        end
      end

      context 'when both a name and a block is given' do
        it 'defines a capture for the pattern' do
          args = [key, name, block]
          pattern_object.should_receive(:define_capture).with(*args)
          subject.capture(key, name, &block)
        end
      end
    end

    describe 'pattern' do
      let(:name) { 'foo' }
      let(:block) { -> {} }

      it 'defines a nested pattern on the pattern' do
        pattern_object.should_receive(:define_pattern).with(name, block)
        subject.should_receive(:pattern_object).and_return(pattern_object)

        subject.pattern(name, &block)
      end
    end

    describe 'include' do
      let(:name) { 'foo' }

      it 'includes a grammar or rule in the pattern' do
        node.should_receive(:include=).with(name)
        subject.include(name)
      end
    end
  end
end
