require 'spec_helper'

describe TmGrammar::Util::Buffer do
  include TmGrammar::Util

  let(:buffer) { subject }
  let(:data) { 'foo' }

  describe 'append' do
    context 'when given one value' do
      it 'appends the given value to the buffer' do
        buffer.append(data)
        buffer.to_s.should == 'foo'
      end

      it 'returns the receiver' do
        buffer.append(data).should == buffer
      end
    end

    context 'when no arguments are given' do
      it 'does not append any data to the buffer' do
        buffer.append.to_s.should be_empty
      end
    end

    context 'when multiple arguments are given' do
      it 'concatenates and appends all the arguments' do
        buffer.append(data, 'bar').to_s.should == "#{data}bar"
      end
    end

    context 'when a Newline is given' do
      it 'concatenates a newline to the buffer' do
        buffer.append(data, nl).to_s.should == "#{data}\n"
      end
    end
  end

  describe '<<' do
    it 'appends the given value to the buffer' do
      buffer << data
      buffer.to_s.should == data
    end
  end

  describe 'to_s' do
    it 'returns the content of the buffer' do
      buffer.append('foo').to_s.should == 'foo'
    end
  end

  describe 'indent' do
    it 'returns the receiver' do
      buffer.indent {}.should == buffer
    end

    context 'when a Newline is appended' do
      it 'indents the next appended value' do
        buffer.indent { buffer.append(nl, data) }.to_s.should == "\n\t#{data}"
      end
    end

    context 'when a non-Newline value is appended' do
      it 'does not indent anything' do
        buffer.indent { buffer.append(data) }.to_s.should == data
      end
    end

    context 'nested indentation' do
      it 'indents twice' do
        buffer.append('foo', nl)

        buffer.indent do
          buffer.append('bar', nl)

          buffer.indent { buffer.append('asd') }
        end

        buffer.to_s.should == "foo\n\tbar\n\t\tasd"
      end
    end

    context 'larger example' do
      let(:buffer) { TmGrammar::Util::Buffer.new('  ') }

      it 'indents correctly' do
        expected = <<-data
{
  patterns = (
    { name = 'foo';
    }
    { name = 'bar';
    }
  )
}
data

        buffer.append('{', nl)

        buffer.indent do
          buffer.append('patterns = (', nl)

          buffer.indent do
            buffer.append("{ name = 'foo';", nl, '}', nl)
          end

          buffer.indent do
            buffer.append("{ name = 'bar';", nl, '}', nl)
          end

          buffer.append(')', nl)
        end

        buffer.append('}')

        buffer.to_s.should == expected.strip
      end
    end
  end
end
