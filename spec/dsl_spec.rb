require 'spec_helper'

describe TmGrammar::Dsl do
  describe TmGrammar::Dsl::Grammar do
    let(:node) { double(:node) }
    subject { Class.new { include TmGrammar::Dsl::Grammar }.new(node) }

    describe 'initialize' do
      it 'initialize the receiver with the given node' do
        subject.node.should == node
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
