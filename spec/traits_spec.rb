require 'spec_helper'

describe TmGrammar::Traits do
  let(:traits) { TmGrammar::Traits }
  let(:name) { :foo }
  let(:block) { -> {} }

  describe 'register_trait' do
    it 'registeres a trait' do
      traits.register_trait(name, block)
      traits.retrieve_trait(name).should == block
    end
  end

  describe 'retrieve_trait' do
    let(:second_name) { :bar }
    let(:second_block) { -> {} }

    it 'retrieves a trait' do
      traits.register_trait(name, block)
      traits.register_trait(second_name, second_block)

      traits.retrieve_trait(name).should == block
    end
  end
end
