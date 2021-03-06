require 'spec_helper'

describe TmGrammar::Pattern do
  let(:grammar) { TmGrammar::Grammar.new('foo', -> {}).node }
  let(:block) { -> {} }
  let(:pattern) { TmGrammar::Pattern.new(grammar, block) }
  let(:node) { pattern.node }

  subject { pattern }

  describe 'initialize' do
    it 'creates a new pattern node' do
      node.should be_a(TmGrammar::Node::Pattern)
    end
  end

  describe 'evaluate' do
    it 'evaluates the pattern block' do
      i = 0
      block = -> { i += 1 }
      pattern = TmGrammar::Pattern.new(grammar, block)
      -> { pattern.evaluate }.should change { i }.by(1)
    end

    it 'evaluates the pattern in a grammar context' do
      context = nil
      block = -> { context = self }
      pattern = TmGrammar::Pattern.new(grammar, block)
      pattern.evaluate
      context.should be_a(TmGrammar::Pattern::Context)
    end

    it 'returns a pattern node' do
      pattern.evaluate.should be_a(TmGrammar::Node::Pattern)
    end
  end

  describe 'define_capture' do
    let(:key) { 1 }
    let(:name) { 'foo' }
    let(:blcok) { -> {} }

    context 'when a name is given' do
      it 'defines a new capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_capture(key, name)
      end
    end

    context 'when a block is given' do
      it 'defines a new capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_capture(key, nil, block)
      end
    end

    context 'when both a name and a block is given' do
      it 'defines a new capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_capture(key, name, block)
      end
    end
  end

  describe 'define_begin_capture' do
    let(:key) { 1 }
    let(:name) { 'foo' }
    let(:blcok) { -> {} }

    context 'when a name is given' do
      it 'defines a new begin capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_begin_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_begin_capture(key, name)
      end
    end

    context 'when a block is given' do
      it 'defines a new begin capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_begin_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_begin_capture(key, nil, block)
      end
    end

    context 'when both a name and a block is given' do
      it 'defines a new begin capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_begin_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_begin_capture(key, name, block)
      end
    end
  end

  describe 'define_end_capture' do
    let(:key) { 1 }
    let(:name) { 'foo' }
    let(:blcok) { -> {} }

    context 'when a name is given' do
      it 'defines a new end capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_end_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_end_capture(key, name)
      end
    end

    context 'when a block is given' do
      it 'defines a new end capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_end_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_end_capture(key, nil, block)
      end
    end

    context 'when both a name and a block is given' do
      it 'defines a new end capture' do
        capture = TmGrammar::Node::Capture
        node.should_receive(:add_end_capture)
          .with(a_kind_of(Integer), an_instance_of(capture)).and_call_original

        pattern.define_end_capture(key, name, block)
      end
    end
  end

  describe 'define_pattern' do
    let(:name) { 'foo' }
    let(:block) { -> {} }

    it 'defines a new pattern' do
      pattern = TmGrammar::Node::Pattern
      node.should_receive(:add_pattern).with(an_instance_of(pattern))
        .and_call_original

      subject.define_pattern(name, block)
    end
  end

  describe 'define_match' do
    let(:block) { -> {} }
    let(:match) { TmGrammar::Match.new(node, block) }

    it 'defines a match' do
      node.should_receive(:match=).with(match).and_call_original
      subject.define_match(block)
    end
  end

  describe 'define_begin_match' do
    let(:block) { -> {} }
    let(:match) { TmGrammar::Match.new(node, block) }

    it 'defines a begin match' do
      node.should_receive(:begin=).with(match).and_call_original
      subject.define_begin_match(block)
    end
  end

  describe 'define_end_match' do
    let(:block) { -> {} }
    let(:match) { TmGrammar::Match.new(node, block) }

    it 'defines a end match' do
      node.should_receive(:end=).with(match).and_call_original
      subject.define_end_match(block)
    end
  end
end
