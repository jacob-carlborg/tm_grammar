require 'spec_helper'

describe TmGrammar::Util::Util do
  let(:util) { Class.new { include TmGrammar::Util::Util }.new }

  describe 'enforce' do
    def enforce
      util.enforce(object, error_message)
    end

    let(:object) { Object.new }
    let(:error_message) { 'foo' }

    context 'when the given object is a truthy value' do
      it 'returns the object' do
        enforce.should == object
      end
    end

    context 'when no error message or block is given' do
      let(:error_message) { nil }

      it 'raises "No error message or block given"' do
        -> { enforce }.should raise_error('No error message or block given')
      end
    end

    context 'when the given object is not a truthy value' do
      let(:object) { nil }

      context 'when an error message is given' do
        it 'raises an error with that error message' do
          -> { enforce }.should raise_error(error_message)
        end
      end

      context 'when a block is given' do
        let(:error_message) { nil }
        let(:block_message) { 'bar' }
        let(:block) { -> { block_message } }

        def enforce
          util.enforce(object, &block)
        end

        it 'raises an error with the contents of the block' do
          -> { enforce }.should raise_error(block_message)
        end
      end
    end
  end
end
