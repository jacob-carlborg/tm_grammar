require 'spec_helper'

describe TmGrammar::Generator::TmLanguageXml do
  let(:options) do
    TmGrammar::Generator::Base::Options.new.tap do |o|
      o.indent = 2
      o.indent_text = ' '
    end
  end

  subject { TmGrammar::Generator::TmLanguageXml.new(options) }

  let(:header) do
    header = <<-grammar
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
grammar

    header.strip
  end

  let(:footer) do
    <<-grammar
</dict>
</plist>
grammar

  end

  def generate
    subject.generate(node)
  end

  def build_result(reslut)
    header + "\n" + reslut[0 ... -1] + "\n" + footer
  end

  describe 'generate' do
    context 'grammar' do
      let(:scope_name) { 'source.foo' }
      let(:node) { TmGrammar::Node::Grammar.new(scope_name) }

      context 'when the grammar has a scope name' do
        it 'generates a TextMate grammar with a scope name' do
          result = <<-grammar
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.to_s.should == build_result(result)
        end
      end

      context 'when the grammar has a folding start marker' do
        it 'generates a TextMate grammar with a folding start marker' do
          node.folding_start_marker = '\{\s*$'
          result = <<-grammar
  <key>foldingStartMarker</key>
  <string>#{node.folding_start_marker}</string>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has a folding stop marker' do
        it 'generates a TextMate grammar with a folding stop marker' do
          node.folding_stop_marker = '^\s*\}'
          result = <<-grammar
  <key>foldingStopMarker</key>
  <string>#{node.folding_stop_marker}</string>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has a first line match' do
        it 'generates a TextMate grammar with a first line match' do
          node.first_line_match = '^#!/.*\bruby\b'
          result = <<-grammar
  <key>firstLineMatch</key>
  <string>#{node.first_line_match}</string>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has a comment' do
        let(:comment) { 'keyword.control.foo' }

        it 'generates a TextMate grammar with a comment' do
          node.comment = comment
          result = <<-grammar
  <key>comment</key>
  <string>#{comment}</string>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has files types' do
        let(:file_type) { 'src' }

        it 'generates a TextMate grammar with a comment' do
          node.file_types = [file_type]
          result = <<-grammar
  <key>fileTypes</key>
  <array>
    <string>#{file_type}</string>
  </array>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has a key equivalent' do
        let(:key_equivalent) { '^~F' }

        it 'generates a TextMate grammar with a key equivalent' do
          node.key_equivalent = key_equivalent
          result = <<-grammar
  <key>keyEquivalent</key>
  <string>#{key_equivalent}</string>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has a uuid' do
        let(:uuid) { '07FD2CA2-93CF-402D-B0F0-FE1F15EC03B7' }

        it 'generates a TextMate grammar with a uuid' do
          node.uuid = uuid
          result = <<-grammar
  <key>scopeName</key>
  <string>#{scope_name}</string>
  <key>uuid</key>
  <string>#{uuid}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the grammar has patterns' do
        let(:pattern_name) { 'keyword.control.foo' }

        context 'when there is one pattern' do
          it 'generates a TextMate grammar with patterns' do
            pattern = TmGrammar::Node::Pattern.new
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern

            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{pattern_name}</string>
    </dict>
  </array>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
          end
        end

        context 'when there are multiple patterns' do
          it 'generates a TextMate grammar with patterns' do
            pattern = TmGrammar::Node::Pattern.new
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern << pattern

            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{pattern_name}</string>
    </dict>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{pattern_name}</string>
    </dict>
  </array>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
          end
        end
      end

      context 'when the grammar has a repository' do
        let(:name) { 'variable' }
        let(:match) { '\$[a-zA-Z0-9_]+' }
        let(:pattern) { TmGrammar::Node::Pattern.new }

        before :each do
          pattern.match = match
          node.repository[name] = pattern
        end

        context 'when there is one rule in the repository' do
          it 'generates a TextMate grammar with a repository' do
            result = <<-grammar
  <key>repository</key>
  <dict>
    <key>#{name}</key>
    <dict>
      <key>match</key>
      <string>#{match}</string>
    </dict>
  </dict>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
          end
        end

        context 'when there are multiple rules' do
          let(:second_name) { 'escaped-char' }
          let(:second_match) { '\\.' }

          it 'generates a TextMate grammar with rules' do
            second_pattern = TmGrammar::Node::Pattern.new
            second_pattern.match = second_match
            node.repository[second_name] = second_pattern

            result = <<-grammar
  <key>repository</key>
  <dict>
    <key>#{second_name}</key>
    <dict>
      <key>match</key>
      <string>#{second_match}</string>
    </dict>
    <key>#{name}</key>
    <dict>
      <key>match</key>
      <string>#{match}</string>
    </dict>
  </dict>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
          end
        end
      end

      context 'when the rules_to_generate option is specified' do
        let(:name) { 'variable' }
        let(:match) { '\$[a-zA-Z0-9_]+' }
        let(:pattern) { TmGrammar::Node::Pattern.new }
        let(:rules_to_generate) { [name] }

        let(:options) do
          super().tap do |o|
            o.rules_to_generate = rules_to_generate
          end
        end

        subject { TmGrammar::Generator::TmLanguageXml.new(options) }

        before :each do
          pattern.match = match
          node.repository[name] = pattern
        end

        it 'generates those rules as patterns' do
            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>match</key>
      <string>#{match}</string>
    </dict>
  </array>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
        end

        context 'when multiple rules are in the repository' do
          let(:rules_to_generate) { [name, name + '2'] }

          before :each do
            node.repository[name + '2'] = pattern
            node.repository[name + '3'] = pattern
          end

          it 'only generates the specified rules' do
            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>match</key>
      <string>#{match}</string>
    </dict>
    <dict>
      <key>match</key>
      <string>#{match}</string>
    </dict>
  </array>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
          end
        end

        context 'when other attributes are specified' do
          it 'does not generate other attributes' do
            node.comment = 'keyword.control.foo'
            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>match</key>
      <string>#{match}</string>
    </dict>
  </array>
  <key>scopeName</key>
  <string>#{scope_name}</string>
grammar
            generate.should == build_result(result)
          end
        end
      end
    end

    context 'pattern' do
      let(:node) { TmGrammar::Node::Pattern.new }

      context 'when the pattern has a name' do
        let(:name) { 'keyword.control.foo' }

        it 'generates a TextMate pattern with a name' do
          node.name = name
          result = <<-grammar
  <key>name</key>
  <string>#{name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a match' do
        it 'generates a TextMate pattern with a match' do
          node.match = '\b(if|while|for|return)\b'
          result = <<-grammar
  <key>match</key>
  <string>#{node.match}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a match which is a regular expression' do
        it 'generates a TextMate pattern with a match' do
          regexp = '\b(if|while|for|return)\b'
          node.match = /#{regexp}/
          result = <<-grammar
  <key>match</key>
  <string>#{regexp}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a begin' do
        it 'generates a TextMate pattern with a begin' do
          node.begin = '"'
          result = <<-grammar
  <key>begin</key>
  <string>#{node.begin}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has an end' do
        it 'generates a TextMate pattern with a end' do
          node.end = '"'
          result = <<-grammar
  <key>end</key>
  <string>#{node.end}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a content name' do
        it 'generates a TextMate pattern with a content name' do
          node.content_name = 'comment.block.preprocessor'
          result = <<-grammar
  <key>contentName</key>
  <string>#{node.content_name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a comment' do
        let(:comment) { 'keyword.control.foo' }

        it 'generates a TextMate pattern with a comment' do
          node.comment = comment
          result = <<-grammar
  <key>comment</key>
  <string>#{node.comment}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a disabled' do
        let(:disabled) { true }

        it 'generates a TextMate pattern with a disabled' do
          node.disabled = disabled
          result = <<-grammar
  <key>disabled</key>
  <integer>1</integer>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has a include' do
        it 'generates a TextMate pattern with a include' do
          node.include = 'source.d'
          result = <<-grammar
  <key>include</key>
  <string>#{node.include}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the pattern has nested patterns' do
        let(:nested_name) { 'keyword.control.foo' }
        let(:pattern) { TmGrammar::Node::Pattern.new }

        before :each do
          pattern.name = nested_name
          pattern.begin = '"'
          node.patterns << pattern
        end

        context 'when there is one nested pattern' do
          it 'generates a TextMate pattern with nested patterns' do
            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{nested_name}</string>
    </dict>
  </array>
grammar
            generate.should == build_result(result)
          end
        end

        context 'when there are multiple nested patterns' do
          it 'generates a TextMate pattern with nested patterns' do
            node.patterns << pattern

            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{nested_name}</string>
    </dict>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{nested_name}</string>
    </dict>
  </array>
grammar
            generate.should == build_result(result)
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
  <key>captures</key>
  <dict>
    <key>#{key}</key>
    <dict>
      <key>name</key>
      <string>#{capture_name}</string>
    </dict>
  </dict>
grammar
            generate.should == build_result(result)
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
  <key>captures</key>
  <dict>
    <key>#{key}</key>
    <dict>
      <key>name</key>
      <string>#{capture_name}</string>
    </dict>
    <key>#{second_key}</key>
    <dict>
      <key>name</key>
      <string>#{capture_name}</string>
    </dict>
  </dict>
grammar
            generate.should == build_result(result)
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
  <key>beginCaptures</key>
  <dict>
    <key>#{key}</key>
    <dict>
      <key>name</key>
      <string>#{begin_capture_name}</string>
    </dict>
  </dict>
grammar
            generate.should == build_result(result)
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
  <key>beginCaptures</key>
  <dict>
    <key>#{key}</key>
    <dict>
      <key>name</key>
      <string>#{begin_capture_name}</string>
    </dict>
    <key>#{second_key}</key>
    <dict>
      <key>name</key>
      <string>#{begin_capture_name}</string>
    </dict>
  </dict>
grammar
            generate.should == build_result(result)
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
  <key>endCaptures</key>
  <dict>
    <key>#{key}</key>
    <dict>
      <key>name</key>
      <string>#{end_capture_name}</string>
    </dict>
  </dict>
grammar
            generate.should == build_result(result)
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
  <key>endCaptures</key>
  <dict>
    <key>#{key}</key>
    <dict>
      <key>name</key>
      <string>#{end_capture_name}</string>
    </dict>
    <key>#{second_key}</key>
    <dict>
      <key>name</key>
      <string>#{end_capture_name}</string>
    </dict>
  </dict>
grammar
            generate.should == build_result(result)
          end
        end
      end

      context 'when a string value contains a single quote' do
        it 'generates a string value with double quotes' do
          node.begin = "'"
          result = <<-grammar
  <key>begin</key>
  <string>#{node.begin}</string>
grammar
          generate.should == build_result(result)
        end
      end
    end

    context 'capture' do
      let(:node) { TmGrammar::Node::Capture.new }

      context 'when the capture has a name' do
        it 'generates a TextMate capture with a name' do
          node.name = 'storage.type.objc'
          result = <<-grammar
  <key>name</key>
  <string>#{node.name}</string>
grammar
          generate.should == build_result(result)
        end
      end

      context 'when the capture has patterns' do
        let(:pattern_name) { 'keyword.control.foo' }

        context 'when there is one pattern' do
          it 'generates a TextMate capture with patterns' do
            pattern = TmGrammar::Node::Pattern.new
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern

            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{pattern_name}</string>
    </dict>
  </array>
grammar
            generate.should == build_result(result)
          end
        end

        context 'when there are multiple patterns' do
          it 'generates a TextMate capture with patterns' do
            pattern = TmGrammar::Node::Pattern.new
            pattern.name = pattern_name
            pattern.begin = '"'
            node.patterns << pattern << pattern

            result = <<-grammar
  <key>patterns</key>
  <array>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{pattern_name}</string>
    </dict>
    <dict>
      <key>begin</key>
      <string>#{pattern.begin}</string>
      <key>name</key>
      <string>#{pattern_name}</string>
    </dict>
  </array>
grammar
            generate.should == build_result(result)
          end
        end
      end
    end
  end
end
