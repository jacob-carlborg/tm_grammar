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
  end
end
