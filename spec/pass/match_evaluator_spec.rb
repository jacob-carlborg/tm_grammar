require 'spec_helper'

describe TmGrammar::Pass::MatchEvaluator do
  Match = TmGrammar::Node::Match

  let(:grammar) { TmGrammar::Node::Grammar.new('source.foo') }
  let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }
  let(:capture_number) { 1 }

  let(:evaluator) do
    TmGrammar::Pass::MatchEvaluator.new(grammar, pattern)
  end

  def evaluate(node)
    evaluator.evaluate(node)
  end

  describe 'evaluate' do
    context 'when the node is a string' do
      let(:node) { 'foo' }

      it 'returns the string' do
        evaluate(node).should == node
      end
    end

    context 'when the node is a regular expression' do
      let(:source) { 'foo' }
      let(:node) { Regexp.new(source) }

      it 'returns the source of the regular expression' do
        evaluate(node).should == source
      end
    end

    context 'when the node is an And node' do
      let(:left) { 'left' }
      let(:right) { 'right' }
      let(:node) { Match::And.new(left, right) }

      it 'concatenates the left and right nodes' do
        evaluate(node).should == left + right
      end
    end

    context 'when the node is a Capture node' do
      let(:inner_node) { 'foo' }
      let(:node) { Match::Capture.new(inner_node) }

      it 'groups the node in a capture group' do
        evaluate(node).should == "(#{inner_node})"
      end
    end

    context 'when the node is a Group node' do
      let(:inner_node) { 'foo' }
      let(:node) { Match::Group.new(inner_node) }

      it 'groups the node in a non-capture group' do
        evaluate(node).should == "(?:#{inner_node})"
      end
    end

    context 'when the node is an Or node' do
      let(:left) { 'left' }
      let(:right) { 'right' }
      let(:node) { Match::Or.new(left, right) }

      it 'ors the left and right nodes' do
        evaluate(node).should == "(?:#{left}|#{right})"
      end
    end

    context 'when the node is a Repetition node' do
      let(:inner_node) { 'value' }
      let(:node) { Match::Repetition.new(inner_node, type) }

      context 'when the repetition is zero or one' do
        let(:type) { Match::Repetition::TYPE_OPTIONAL }

        it 'returns the corresponding regular expression' do
          evaluate(node).should == "(?:#{inner_node})?"
        end
      end

      context 'when the repetition is zero or more' do
        let(:type) { Match::Repetition::TYPE_ZERO_OR_MORE }

        it 'returns the corresponding regular expression' do
          evaluate(node).should == "(?:#{inner_node})*"
        end
      end

      context 'when the repetition is one or more' do
        let(:type) { Match::Repetition::TYPE_ONE_OR_MORE }

        it 'returns the corresponding regular expression' do
          evaluate(node).should == "(?:#{inner_node})+"
        end
      end

      context 'when the inner node is a RuleReference node' do
        let(:rule) { 'rule' }
        let(:referenced_pattern) { pattern }
        let(:containing_pattern) { TmGrammar::Node::Pattern.new(grammar) }
        let(:inner_node) { Match::RuleReference.new(rule, containing_pattern) }

        before :each do
          pattern.match = 'foo'
          grammar.add_rule(rule, referenced_pattern)
        end

        context 'when the repetition is zero or one' do
          let(:type) { Match::Repetition::TYPE_OPTIONAL }

          it 'returns the corresponding regular expression' do
            evaluate(node).should == "(?:(#{pattern.match}))?"
          end
        end

        context 'when the repetition is zero or more' do
          let(:type) { Match::Repetition::TYPE_ZERO_OR_MORE }

          it 'returns the corresponding regular expression' do
            evaluate(node).should == "((#{pattern.match})*)"
          end
        end

        context 'when the repetition is one or more' do
          let(:type) { Match::Repetition::TYPE_ONE_OR_MORE }

          it 'returns the corresponding regular expression' do
            evaluate(node).should == "((#{pattern.match})+)"
          end
        end
      end
    end

    context 'when the node is a RuleReference node' do
      let(:rule) { 'rule' }
      let(:referenced_pattern) { pattern }
      let(:containing_pattern) { TmGrammar::Node::Pattern.new(grammar) }
      let(:node) { Match::RuleReference.new(rule, containing_pattern) }

      before :each do
        pattern.match = 'foo'
        grammar.add_rule(rule, referenced_pattern)
      end

      it "returns the pattern's match of the rule wrapped in a capture group" do
        evaluate(node).should == "(#{pattern.match})"
      end

      it 'adds a capture for the reference pattern' do
        evaluate(node)
        patterns = containing_pattern.captures[1].patterns
        patterns.first.include.should == "##{rule}"
      end
    end

    context 'when the node is a Pattern node' do
      let(:match) { 'foo' }

      let(:node) do
        TmGrammar::Node::Pattern.new(grammar).tap { |e| e.match = match }
      end

      it 'returns the evaluated value of match' do
        evaluate(node).should == match
      end
    end

    context 'when the node is a Term node' do
      let(:value) { 'foo' }
      let(:node) { Match::Term.new(value) }

      it 'returns value of the term node' do
        evaluate(node).should == value
      end
    end
  end
end
