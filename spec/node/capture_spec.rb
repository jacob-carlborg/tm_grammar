require 'spec_helper'

describe TmGrammar::Node::Capture do
  let(:number) { 1 }
  let(:name) { 'keyword.control.foo' }
  let(:capture) { TmGrammar::Node::Capture.new(number, name) }

  describe 'initialize' do
    it 'initializes the object with the given number and name' do
      capture.number.should == number
      capture.name.should == name
    end
  end
end
