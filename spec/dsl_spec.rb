require 'spec_helper'

describe TmGrammar::Dsl do
  shared_examples 'shared' do
    describe 'mixin' do
      let(:name) { :foo }
      let(:block) { -> { bar } }

      it 'mixes in a trait' do
        subject.should_receive(:bar)

        TmGrammar::Traits.register_trait(name, block)
        subject.mixin(name)
      end
    end
  end

  describe TmGrammar::Dsl::Shared do
    subject { Class.new { include TmGrammar::Dsl::Shared }.new }
    include_examples 'shared'
  end

  describe TmGrammar::Dsl::Global do
    subject { Class.new { include TmGrammar::Dsl::Global }.new }

    describe 'grammar' do
      let(:scope_name) { 'source.foo' }
      let(:block) { -> {} }

      it 'defines a grammar' do
        TmGrammar::Grammar.should_receive(:new).with(scope_name, block)
          .and_call_original

        subject.grammar(scope_name, &block)
      end
    end

    describe 'trait' do
      let(:name) { :foo }
      let(:block) { -> {} }

      it 'declares a trait' do
        TmGrammar::Traits.should_receive(:register_trait).with(name, block)
          .and_call_original

        subject.send(:trait, name, &block)
      end
    end

    describe 'imports' do
      let(:path) { 'foo/bar' }

      before :each do
        File.stub(:exist?).and_return(exist_resut)
        subject.should_receive(:require).with(expected)
      end

      context 'when a file with the .tm_lang extension exists' do
        let(:exist_resut) { true }

        let(:expected) do
          File.join(File.dirname(__FILE__), path) + '.tm_lang.rb'
        end

        it 'requires a .tm_lang file relatively' do
          subject.import(path)
        end
      end

      context 'when a file with the .tm_lang extension does not exist' do
        let(:exist_resut) { false }
        let(:expected) { File.join(File.dirname(__FILE__), path) }

        it 'fallbacks to standard require_relative' do
          subject.import(path)
        end
      end
    end
  end

  describe TmGrammar::Dsl::Grammar do
    include_examples 'shared'

    let(:grammar) { TmGrammar::Grammar.new('foo', -> {}) }
    let(:node) { grammar.node }
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
        node.should_receive(:file_types=).with(file_types).and_call_original

        subject.file_types(file_types)
      end
    end

    describe 'folding_start_marker' do
      let(:marker) { /\{\s*$/ }

      it 'sets the folding start marker on the grammar node' do
        node.should_receive(:folding_start_marker=).with(marker)
          .and_call_original

        subject.folding_start_marker(marker)
      end
    end

    describe 'folding_start_marker' do
      let(:marker) { /^\s*\}/ }

      it 'sets the folding stop marker on the grammar node' do
        node.should_receive(:folding_stop_marker=).with(marker)
          .and_call_original

        subject.folding_stop_marker(marker)
      end
    end

    describe 'comment' do
      let(:comment) { 'foo' }

      it 'sets the comment on the pattern node' do
        node.should_receive(:comment=).with(comment).and_call_original
        subject.comment(comment)
      end
    end

    describe 'name' do
      let(:name) { 'foo' }

      it 'sets the name on the pattern node' do
        node.should_receive(:name=).with(name).and_call_original
        subject.name(name)
      end
    end

    describe 'key_equivalent' do
      let(:key_equivalent) { '^~F' }

      it 'sets the key_equivalent on the pattern node' do
        node.should_receive(:key_equivalent=).with(key_equivalent)
          .and_call_original

        subject.key_equivalent(key_equivalent)
      end
    end

    describe 'uuid' do
      let(:uuid) { '07FD2CA2-93CF-402D-B0F0-FE1F15EC03B7' }

      it 'sets the uuid on the pattern node' do
        node.should_receive(:uuid=).with(uuid).and_call_original
        subject.uuid(uuid)
      end
    end

    describe 'first_line_match' do
      let(:first_line_match) { '^#!.*\bg?dmd\b.' }

      it 'sets the first_line_match on the pattern node' do
        node.should_receive(:first_line_match=).with(first_line_match)
          .and_call_original

        subject.first_line_match(first_line_match)
      end
    end

    describe 'pattern' do
      let(:name) { 'foo' }
      let(:block) { -> {} }

      it 'defines a pattern on the grammar' do
        grammar.should_receive(:define_pattern).with(name, block)
          .and_call_original

        subject.pattern(name, &block)
      end

      context 'when no name is given' do
        it 'defines a pattern on the grammar' do
          grammar.should_receive(:define_pattern).with(nil, block)
            .and_call_original

          subject.pattern(&block)
        end
      end
    end

    describe 'rule' do
      let(:name) { 'foo' }
      let(:block) { -> {} }

      it 'defines a rule in the repository' do
        grammar.should_receive(:define_rule).with(name, block)
          .and_call_original

        subject.rule(name, &block)
      end
    end
  end

  describe TmGrammar::Dsl::Pattern do
    include_examples 'shared'

    let(:grammar) { TmGrammar::Grammar.new('foo', -> {}).node }
    let(:pattern_object) { TmGrammar::Pattern.new(grammar, -> {}) }
    let(:node) { pattern_object.node }

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
        node.should_receive(:name=).with(name).and_call_original
        subject.name(name)
      end
    end

    describe 'match' do
      let(:match) { /foo/ }

      it 'sets the match on the pattern node' do
        node.should_receive(:match=).with(match).and_call_original
        subject.match(match)
      end

      context 'with block' do
        let(:block) { -> {} }

        it 'defines a match for the pattern' do
          pattern_object.should_receive(:define_match).with(block)
            .and_call_original

          subject.match(&block)
        end
      end
    end

    describe 'begin' do
      let(:match) { /foo/ }

      it 'sets the begin match on the pattern node' do
        node.should_receive(:begin=).with(match).and_call_original
        subject.begin(match)
      end

      context 'with block' do
        let(:block) { -> {} }

        it 'defines a match for the pattern' do
          pattern_object.should_receive(:define_begin_match).with(block)
            .and_call_original

          subject.begin(&block)
        end
      end
    end

    describe 'end' do
      let(:match) { /foo/ }

      it 'sets the end match on the pattern node' do
        node.should_receive(:end=).with(match).and_call_original
        subject.end(match)
      end

      context 'with block' do
        let(:block) { -> {} }

        it 'defines a match for the pattern' do
          pattern_object.should_receive(:define_end_match).with(block)
            .and_call_original

          subject.end(&block)
        end
      end
    end

    describe 'content_name' do
      let(:name) { 'foo' }

      it 'sets the content name on the pattern node' do
        node.should_receive(:content_name=).with(name).and_call_original
        subject.content_name(name)
      end
    end

    describe 'comment' do
      let(:comment) { 'foo' }

      it 'sets the comment on the pattern node' do
        node.should_receive(:comment=).with(comment).and_call_original
        subject.comment(comment)
      end
    end

    describe 'disabled' do
      let(:disabled) { 'foo' }

      it 'sets the disabled on the pattern node' do
        node.should_receive(:disabled=).with(disabled).and_call_original
        subject.disabled(disabled)
      end
    end

    describe 'capture' do
      let(:key) { 1 }
      let(:name) { 'foo' }
      let(:block) { -> {} }

      context 'when a name is given' do
        it 'defines a capture for the pattern' do
          pattern_object.should_receive(:define_capture)
            .with(key, name, nil).and_call_original

          subject.capture(key, name)
        end
      end

      context 'when a block is given' do
        it 'defines a capture for the pattern' do
          args = [key, nil, block]
          pattern_object.should_receive(:define_capture).with(*args)
            .and_call_original

          subject.capture(key, &block)
        end
      end

      context 'when both a name and a block is given' do
        it 'defines a capture for the pattern' do
          args = [key, name, block]
          pattern_object.should_receive(:define_capture).with(*args)
            .and_call_original

          subject.capture(key, name, &block)
        end
      end
    end

    describe 'pattern' do
      let(:name) { 'foo' }
      let(:block) { -> {} }

      it 'defines a nested pattern on the pattern' do
        pattern_object.should_receive(:define_pattern).with(name, block)
          .and_call_original

        subject.pattern(name, &block)
      end
    end

    describe 'include' do
      let(:name) { 'foo' }

      it 'includes a grammar or rule in the pattern' do
        node.should_receive(:include=).with(name).and_call_original
        subject.include(name)
      end
    end

    describe 'begin_capture' do
      let(:number) { 1 }
      let(:name) { 'foo' }
      let(:block) { -> {} }

      context 'when a name is given' do
        it 'defines a begin capture for the pattern' do
          pattern_object.should_receive(:define_begin_capture)
            .with(number, name, nil).and_call_original

          subject.begin_capture(number, name)
        end
      end

      context 'when a block is given' do
        it 'defines a capture for the pattern' do
          args = [number, nil, block]
          pattern_object.should_receive(:define_begin_capture).with(*args)
            .and_call_original

          subject.begin_capture(number, &block)
        end
      end

      context 'when both a name and a block is given' do
        it 'defines a capture for the pattern' do
          args = [number, name, block]
          pattern_object.should_receive(:define_begin_capture).with(*args)
            .and_call_original

          subject.begin_capture(number, name, &block)
        end
      end
    end

    describe 'end_capture' do
      let(:number) { 1 }
      let(:name) { 'foo' }
      let(:block) { -> {} }

      context 'when a name is given' do
        it 'defines a end capture for the pattern' do
          pattern_object.should_receive(:define_end_capture)
            .with(number, name, nil).and_call_original

          subject.end_capture(number, name)
        end
      end

      context 'when a block is given' do
        it 'defines a capture for the pattern' do
          args = [number, nil, block]
          pattern_object.should_receive(:define_end_capture).with(*args)
            .and_call_original

          subject.end_capture(number, &block)
        end
      end

      context 'when both a name and a block is given' do
        it 'defines a capture for the pattern' do
          args = [number, name, block]
          pattern_object.should_receive(:define_end_capture).with(*args)
            .and_call_original

          subject.end_capture(number, name, &block)
        end
      end
    end
  end

  describe TmGrammar::Dsl::Capture do
    include_examples 'shared'

    let(:grammar) { TmGrammar::Grammar.new('foo', -> {}).node }
    let(:capture) { TmGrammar::Capture.new(grammar, 'foo', -> {}) }
    let(:node) { capture.node }
    subject { Class.new { include TmGrammar::Dsl::Capture }.new(capture, node) }

    describe 'pattern' do
      let(:name) { 'foo' }
      let(:block) { -> {} }

      it 'defines a pattern on the capture' do
        capture.should_receive(:define_pattern).with(name, block)
          .and_call_original

        subject.pattern(name, &block)
      end

      context 'when no name is given' do
        it 'defines a pattern on the capture' do
          capture.should_receive(:define_pattern).with(nil, block)
            .and_call_original

          subject.pattern(&block)
        end
      end
    end
  end

  describe TmGrammar::Dsl::Match do
    let(:grammar) { TmGrammar::Node::Grammar.new('source.foo') }
    let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }
    subject { Class.new { include TmGrammar::Dsl::Match }.new(pattern) }

    describe 'initialize' do
      it 'initialize the receiver with the given grammar and node' do
        subject.pattern.should == pattern
      end
    end

    describe '´' do
      it 'returns a Term match node' do
        type = TmGrammar::Node::Match::Term
        subject.instance_eval { `foo` }.should be_a(type)
      end

      it 'the returned node contains the given value' do
        subject.instance_eval { `foo` }.value.should == 'foo'
      end
    end

    describe 'method_missing' do
      let(:name) { :foo }

      it 'returns a RuleReference match node' do
        type = TmGrammar::Node::Match::RuleReference
        subject.method_missing(name).should be_a(type)
      end

      it 'the returned node contains the name of the called method' do
        subject.method_missing(name).rule.should == name
      end

      context 'when the name ends with ?' do
        let(:name) { :foo? }

        it 'returns an optional match node' do
          subject.method_missing(name).should be_optional
        end

        it 'the optional node is a RuleReference match node' do
          type = TmGrammar::Node::Match::RuleReference
          subject.method_missing(name).node.should be_a(type)
        end

        it 'the name of the RuleReference node does not contain ?' do
          subject.method_missing(name).node.rule.to_s.should_not include('?')
        end
      end
    end

    describe 'optional' do
      let(:node) { 'foo' }

      it 'returns a Repetition match node' do
        type = TmGrammar::Node::Match::Repetition
        subject.optional(node).should be_a(type)
      end

      it 'the returned node contains the given node' do
        subject.optional(node).node.should == node
      end

      it 'the returned node has the repetition type optional' do
        type = TmGrammar::Node::Match::Repetition::TYPE_OPTIONAL
        subject.optional(node).type.should == type
      end
    end

    describe 'zero_or_more' do
      let(:node) { 'foo' }

      it 'returns a Repetition match node' do
        type = TmGrammar::Node::Match::Repetition
        subject.zero_or_more(node).should be_a(type)
      end

      it 'the returned node contains the given node' do
        subject.zero_or_more(node).node.should == node
      end

      it 'the returned node has the repetition type zero or more' do
        type = TmGrammar::Node::Match::Repetition::TYPE_ZERO_OR_MORE
        subject.zero_or_more(node).type.should == type
      end
    end

    describe 'one_or_more' do
      let(:node) { 'foo' }

      it 'returns a Repetition match node' do
        type = TmGrammar::Node::Match::Repetition
        subject.one_or_more(node).should be_a(type)
      end

      it 'the returned node contains the given node' do
        subject.one_or_more(node).node.should == node
      end

      it 'the returned node has the repetition type one or more' do
        type = TmGrammar::Node::Match::Repetition::TYPE_ONE_OR_MORE
        subject.one_or_more(node).type.should == type
      end
    end

    describe 'capture' do
      let(:node) { 'foo' }

      it 'returns a Capture match node' do
        type = TmGrammar::Node::Match::Capture
        subject.capture(node).should be_a(type)
      end

      context 'named capture' do
        it 'returns a Capture match node' do
          type = TmGrammar::Node::Match::Capture
          subject.capture(:foo, node).should be_a(type)
        end

        it 'correctly sets the node' do
          capture = subject.capture(:foo, node)
          capture.node.should == node
        end

        it 'correctly sets the name' do
          name = :foo
          capture = subject.capture(name, node)
          capture.name.should == name
        end
      end
    end

    describe 'word_boundary' do
      let(:value) { 'foo' }

      it 'returns a WordBoundary match node' do
        type = TmGrammar::Node::Match::WordBoundary
        subject.word_boundary(value).should be_a(type)
      end

      it 'returns a Group match node wrapped in a WordBoundary match node' do
        type = TmGrammar::Node::Match::Group
        subject.word_boundary(value).node.should be_a(type)
      end

      context 'when the value is a hash' do
        let(:node) { 'bar' }
        let(:name) { :foo }
        let(:value) { { name => node } }

        it 'returns a Capture match node wrapped in a WordBoundary match ' \
          'node' do
          type = TmGrammar::Node::Match::Capture
          subject.word_boundary(value).node.should be_a(type)
        end

        it 'correctly sets the node' do
          subject.word_boundary(value).node.node.should == node
        end

        it 'correctly sets the name' do
          subject.word_boundary(value).node.name.should == name
        end
      end

      context 'when the value is a symbol' do
        let(:value) { :foo }

        it 'returns a Capture match node wrapped in a WordBoundary match ' \
          'node' do
          type = TmGrammar::Node::Match::Capture
          subject.word_boundary(value).node.should be_a(type)
        end

        it 'sets the value as the node' do
          subject.word_boundary(value).node.node.should == value.to_s
        end

        it 'sets the value as the name' do
          subject.word_boundary(value).node.name.should == value.to_s
        end
      end
    end
  end
end
