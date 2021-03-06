require 'spec_helper'

describe TmGrammar::Generator::TextMateGrammar do
  let(:options) do
    TmGrammar::Generator::Base::Options.new.tap do |o|
      o.indent = 2
      o.indent_text = ' '
    end
  end

  let(:scope_name) { 'source.foo' }
  let(:grammar) { TmGrammar::Node::Grammar.new(scope_name) }

  subject { TmGrammar::Generator::TextMateGrammar.new(options) }

  def generate
    subject.generate(node).to_s
  end

  describe 'generate' do
    context 'grammar' do
      let(:node) { grammar }

      context 'when the grammar has a scope name' do
        it 'generates a TextMate grammar with a scope name' do
          result = <<-grammar
{
  scopeName = '#{scope_name}';
}
grammar
          generate.to_s.should == result.strip
        end
      end

      context 'when the grammar has a folding start marker' do
        it 'generates a TextMate grammar with a folding start marker' do
          node.folding_start_marker = '\{\s*$'
          result = <<-grammar
{
  scopeName = '#{scope_name}';
  foldingStartMarker = '#{node.folding_start_marker}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the grammar has a folding stop marker' do
        it 'generates a TextMate grammar with a folding stop marker' do
          node.folding_stop_marker = '^\s*\}'
          result = <<-grammar
{
  scopeName = '#{scope_name}';
  foldingStopMarker = '#{node.folding_stop_marker}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the grammar has a first line match' do
        it 'generates a TextMate grammar with a first line match' do
          node.first_line_match = '^#!/.*\bruby\b'
          result = <<-grammar
{
  scopeName = '#{scope_name}';
  firstLineMatch = '#{node.first_line_match}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the grammar has a comment' do
        let(:comment) { 'keyword.control.foo' }

        it 'generates a TextMate grammar with a comment' do
          node.comment = comment
          result = <<-grammar
{
  scopeName = '#{scope_name}';
  comment = '#{comment}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the grammar has patterns' do
        let(:pattern_name) { 'keyword.control.foo' }

        context 'when there is one pattern' do
          it 'generates a TextMate grammar with patterns' do
            pattern = TmGrammar::Node::Pattern.new(grammar)
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern

            result = <<-grammar
{
  scopeName = '#{scope_name}';
  patterns = (
    {
      name = '#{pattern_name}';
      begin = '#{pattern.begin}';
    }
  );
}
grammar
            generate.should == result.strip
          end
        end

        context 'when there are multiple patterns' do
          it 'generates a TextMate grammar with patterns' do
            pattern = TmGrammar::Node::Pattern.new(grammar)
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern << pattern

            result = <<-grammar
{
  scopeName = '#{scope_name}';
  patterns = (
    {
      name = '#{pattern_name}';
      begin = '#{pattern.begin}';
    },
    {
      name = '#{pattern_name}';
      begin = '#{pattern.begin}';
    }
  );
}
grammar
            generate.should == result.strip
          end
        end
      end

      context 'when the grammar has a repository' do
        let(:name) { 'variable' }
        let(:match) { '\$[a-zA-Z0-9_]+' }
        let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }

        before :each do
          pattern.match = match
          node.repository[name] = pattern
        end

        context 'when there is one rule in the repository' do
          it 'generates a TextMate grammar with a repository' do
            result = <<-grammar
{
  scopeName = '#{scope_name}';
  repository = {
    #{name} = {
      match = '#{match}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end

        context 'when there are multiple rules' do
          let(:second_name) { 'escaped-char' }
          let(:second_match) { '\\.' }

          it 'generates a TextMate grammar with rules' do
            second_pattern = TmGrammar::Node::Pattern.new(grammar)
            second_pattern.match = second_match
            node.repository[second_name] = second_pattern

            result = <<-grammar
{
  scopeName = '#{scope_name}';
  repository = {
    #{name} = {
      match = '#{match}';
    };
    #{second_name} = {
      match = '#{second_match}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end
      end

      context 'when the rules_to_generate option is specified' do
        let(:name) { 'variable' }
        let(:match) { '\$[a-zA-Z0-9_]+' }
        let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }
        let(:rules_to_generate) { [name] }

        let(:options) do
          super().tap { |o| o.rules_to_generate = rules_to_generate }
        end

        subject { TmGrammar::Generator::TextMateGrammar.new(options) }

        before :each do
          pattern.match = match
          node.repository[name] = pattern
        end

        it 'generates those rules as patterns' do
          result = <<-grammar
{
  scopeName = '#{scope_name}';
  patterns = (
    {
      match = '#{match}';
    }
  );
  repository = {
    variable = {
      match = '#{match}';
    };
  };
}
grammar

          generate.should == result.strip
        end

        context 'when multiple rules are in the repository' do
          let(:rules_to_generate) { [name, name + '2'] }

          before :each do
            node.repository[name + '2'] = pattern
            node.repository[name + '3'] = pattern
          end

          it 'only generates the specified rules' do
            result = <<-grammar
{
  scopeName = '#{scope_name}';
  patterns = (
    {
      match = '#{match}';
    },
    {
      match = '#{match}';
    }
  );
  repository = {
    variable = {
      match = '#{match}';
    };
    variable2 = {
      match = '#{match}';
    };
    variable3 = {
      match = '#{match}';
    };
  };
}
grammar

            generate.should == result.strip
          end
        end

        context 'when other attributes are specified' do
          it 'does not generate other attributes' do
            node.comment = 'keyword.control.foo'
            result = <<-grammar
{
  scopeName = '#{scope_name}';
  patterns = (
    {
      match = '#{match}';
    }
  );
  repository = {
    variable = {
      match = '#{match}';
    };
  };
}
grammar

            generate.should == result.strip
          end
        end
      end
    end

    context 'pattern' do
      let(:node) { TmGrammar::Node::Pattern.new(grammar) }

      context 'when the pattern has a name' do
        let(:name) { 'keyword.control.foo' }

        it 'generates a TextMate pattern with a name' do
          node.name = name
          result = <<-grammar
{
  name = '#{name}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a match' do
        it 'generates a TextMate pattern with a match' do
          node.match = '\b(if|while|for|return)\b'
          result = <<-grammar
{
  match = '#{node.match}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a match which is a regular expression' do
        it 'generates a TextMate pattern with a match' do
          regexp = '\b(if|while|for|return)\b'
          node.match = /#{regexp}/
          result = <<-grammar
{
  match = '#{regexp}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a begin' do
        it 'generates a TextMate pattern with a begin' do
          node.begin = '"'
          result = <<-grammar
{
  begin = '#{node.begin}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a end' do
        it 'generates a TextMate pattern with a end' do
          node.end = '"'
          result = <<-grammar
{
  end = '#{node.end}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a content name' do
        it 'generates a TextMate pattern with a content name' do
          node.content_name = 'comment.block.preprocessor'
          result = <<-grammar
{
  contentName = '#{node.content_name}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a comment' do
        let(:comment) { 'keyword.control.foo' }

        it 'generates a TextMate pattern with a comment' do
          node.comment = comment
          result = <<-grammar
{
  comment = '#{comment}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a disabled' do
        let(:disabled) { true }

        it 'generates a TextMate pattern with a disabled' do
          node.disabled = disabled
          result = <<-grammar
{
  disabled = 1;
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has a include' do
        it 'generates a TextMate pattern with a include' do
          node.include = 'source.d'
          result = <<-grammar
{
  include = '#{node.include}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the pattern has nested patterns' do
        let(:nested_name) { 'keyword.control.foo' }
        let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }

        before :each do
          pattern.name = nested_name
          pattern.begin = '"'
          node.patterns << pattern
        end

        context 'when there is one nested pattern' do
          it 'generates a TextMate pattern with nested patterns' do
            result = <<-grammar
{
  patterns = (
    {
      name = '#{nested_name}';
      begin = '#{pattern.begin}';
    }
  );
}
grammar
            generate.should == result.strip
          end
        end

        context 'when there are multiple nested patterns' do
          it 'generates a TextMate pattern with nested patterns' do
            node.patterns << pattern

            result = <<-grammar
{
  patterns = (
    {
      name = '#{nested_name}';
      begin = '#{pattern.begin}';
    },
    {
      name = '#{nested_name}';
      begin = '#{pattern.begin}';
    }
  );
}
grammar
            generate.should == result.strip
          end
        end
      end

      context 'when the pattern has captures' do
        let(:key) { 1 }
        let(:capture_name) { 'storage.type.objc' }
        let(:capture) { TmGrammar::Node::Capture.new }

        before :each do
          node.captures[key] = capture
        end

        context 'when there is one capture' do
          it 'generates a TextMate pattern with captures' do
            capture.name = capture_name

            result = <<-grammar
{
  captures = {
    #{key} = {
      name = '#{capture_name}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end

        context 'when there are multiple captures' do
          let(:second_key) { 3 }

          it 'generates a TextMate pattern with captures' do
            capture.name = capture_name
            second_capture = TmGrammar::Node::Capture.new
            second_capture.name = capture_name
            node.captures[second_key] = second_capture

            result = <<-grammar
{
  captures = {
    #{key} = {
      name = '#{capture_name}';
    };
    #{second_key} = {
      name = '#{capture_name}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end
      end

      context 'when the pattern has begin captures' do
        let(:key) { 1 }
        let(:begin_capture_name) { 'storage.type.objc' }
        let(:begin_capture) { TmGrammar::Node::Capture.new }

        before :each do
          node.begin_captures[key] = begin_capture
        end

        context 'when there is one begin capture' do
          it 'generates a TextMate pattern with begin captures' do
            begin_capture.name = begin_capture_name

            result = <<-grammar
{
  beginCaptures = {
    #{key} = {
      name = '#{begin_capture_name}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end

        context 'when there are multiple begin captures' do
          let(:second_key) { 3 }

          it 'generates a TextMate pattern with begin captures' do
            begin_capture.name = begin_capture_name
            second_begin_capture = TmGrammar::Node::Capture.new
            second_begin_capture.name = begin_capture_name
            node.begin_captures[second_key] = second_begin_capture

            result = <<-grammar
{
  beginCaptures = {
    #{key} = {
      name = '#{begin_capture_name}';
    };
    #{second_key} = {
      name = '#{begin_capture_name}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end
      end

      context 'when the pattern has end captures' do
        let(:key) { 1 }
        let(:end_capture_name) { 'storage.type.objc' }
        let(:end_capture) { TmGrammar::Node::Capture.new }

        before :each do
          node.end_captures[key] = end_capture
        end

        context 'when there is one end capture' do
          it 'generates a TextMate pattern with end captures' do
            end_capture.name = end_capture_name

            result = <<-grammar
{
  endCaptures = {
    #{key} = {
      name = '#{end_capture_name}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end

        context 'when there are multiple end captures' do
          let(:second_key) { 3 }

          it 'generates a TextMate pattern with end captures' do
            end_capture.name = end_capture_name
            second_end_capture = TmGrammar::Node::Capture.new
            second_end_capture.name = end_capture_name
            node.end_captures[second_key] = second_end_capture

            result = <<-grammar
{
  endCaptures = {
    #{key} = {
      name = '#{end_capture_name}';
    };
    #{second_key} = {
      name = '#{end_capture_name}';
    };
  };
}
grammar
            generate.should == result.strip
          end
        end
      end

      context 'when a string value contains a single quote' do
        it 'generates a string value with double quotes' do
          node.begin = "'"
          result = <<-grammar
{
  begin = "#{node.begin}";
}
grammar
          generate.should == result.strip
        end
      end
    end

    context 'capture' do
      let(:node) { TmGrammar::Node::Capture.new }

      context 'when the capture has a name' do
        it 'generates a TextMate capture with a name' do
          node.name = 'storage.type.objc'
          result = <<-grammar
{
  name = '#{node.name}';
}
grammar
          generate.should == result.strip
        end
      end

      context 'when the capture has patterns' do
        let(:pattern_name) { 'keyword.control.foo' }

        context 'when there is one pattern' do
          it 'generates a TextMate capture with patterns' do
            pattern = TmGrammar::Node::Pattern.new(grammar)
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern

            result = <<-capture
{
  patterns = (
    {
      name = '#{pattern_name}';
      begin = '#{pattern.begin}';
    }
  );
}
capture
            generate.should == result.strip
          end
        end

        context 'when there are multiple patterns' do
          it 'generates a TextMate capture with patterns' do
            pattern = TmGrammar::Node::Pattern.new(grammar)
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern << pattern

            result = <<-capture
{
  patterns = (
    {
      name = '#{pattern_name}';
      begin = '#{pattern.begin}';
    },
    {
      name = '#{pattern_name}';
      begin = '#{pattern.begin}';
    }
  );
}
capture
            generate.should == result.strip
          end
        end
      end
    end
  end
end
