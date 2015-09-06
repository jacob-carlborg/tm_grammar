require 'spec_helper'

describe TmGrammar::Node::Capture do
  let(:capture) { TmGrammar::Node::Capture.new }

  describe 'initialize' do
    it 'initializes the object ' do
      capture.should be_a(TmGrammar::Node::Capture)
    end
  end
end
