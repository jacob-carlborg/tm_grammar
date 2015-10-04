require 'spec_helper'

describe TmGrammar::Node::Match::RuleReference do
  RuleReference = TmGrammar::Node::Match::RuleReference

  let(:grammar) { TmGrammar::Node::Grammar.new('source.foo') }
  let(:pattern) { TmGrammar::Node::Pattern.new(grammar) }

  let(:second_grammar) { TmGrammar::Node::Grammar.new('source.foo2') }
  let(:containing_pattern) { TmGrammar::Node::Pattern.new(grammar) }

  let(:rule) { 'rule' }
  let(:node) { RuleReference.new(rule, containing_pattern) }

  describe 'deconstruct' do
    before :each do
      grammar.add_rule(rule, pattern)
    end

    context 'when a RuleReference node is given' do
      it 'returns the rule and containing pattern' do
        deconstructed_object = [rule, containing_pattern, pattern]
        RuleReference.deconstruct(node).should == deconstructed_object
      end
    end

    context 'when another type is given' do
      it 'raises an PatternMatch::PatternNotMatch error' do
        error = PatternMatch::PatternNotMatch
        -> { RuleReference.deconstruct('foo') }.should raise_error(error)
      end
    end
  end

  describe 'initialize' do
    it 'initialize the object with the given rule' do
      node.rule.should == rule
    end

    it 'initialize the object with the given pattern' do
      node.containing_pattern.should == containing_pattern
    end
  end

  describe 'referenced_pattern' do
    context 'when the rule is declared' do
      before :each do
        grammar.add_rule(rule, pattern)
      end

      it 'returns the pattern of the rule' do
        node.referenced_pattern.should == pattern
      end

      context 'when the specified rule is a symbol' do
        let(:node) { RuleReference.new(rule.to_sym, pattern) }

        it 'returns the pattern of the rule' do
          node.referenced_pattern.should == pattern
        end
      end
    end

    context 'when the rule is node declared' do
      it "raises Undeclared rule 'rule'" do
        error_message = "Undeclared rule '#{rule}'"
        -> { node.referenced_pattern }.should raise_error(error_message)
      end
    end
  end

  describe '==' do
    context 'when two nodes are equal' do
      it 'returns true' do
        node.should == node.dup
      end
    end

    context 'when two nodes are not equal' do
      it 'returns false' do
        node.should_not == RuleReference.new(rule + 'bar', nil)
      end
    end

    context 'when the other value is not a RuleReference' do
      it 'should not raise an exception' do
        -> { node == 'foo' }.should_not raise_exception
      end

      it 'return false' do
        node.should_not == 'foo'
      end
    end

    context 'when the rules are not equal' do
      it 'returns false' do
        node.should_not == RuleReference.new(rule + 'bar', pattern)
      end
    end

    context 'when the patterns are not equal' do
      it 'returns false' do
        node.should_not == RuleReference.new(rule, nil)
      end
    end
  end

  describe 'to_s' do
    subject { node.to_s }
    it { should == "RuleReference(#{rule})" }
  end
end
