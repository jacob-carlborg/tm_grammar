require 'spec_helper'

describe TmGrammar::Application do
  let(:input_file) { 'foo' }
  let(:raw_args) { [input_file] }
  let(:application) { TmGrammar::Application.new(raw_args) }

  before :each do
    application.stub(:puts)
    TmGrammar::Parser.any_instance.stub(:parse_from_file)
  end

  describe 'run' do
    it 'calls the parser' do
      TmGrammar::Generator::TmLanguageXml.any_instance.stub(:generate)
      TmGrammar::Parser.any_instance.should_receive(:parse_from_file)
        .with(input_file)

      application.run
    end

    it 'calls the generator' do
      TmGrammar::Generator::TmLanguageXml.any_instance.should_receive(:generate)
      application.run
    end

    context 'when the requested format is "xml"' do
      let(:raw_args) { super() + ['--format', 'xml'] }

      it 'instantiates the TmLanguageXml generator' do
        TmGrammar::Generator::TmLanguageXml
          .any_instance.should_receive(:generate)

        application.run
      end
    end

    context 'when the requested format is "plist"' do
      let(:raw_args) { super() + ['--format', 'plist'] }

      it 'instantiates the TextMateGrammar generator' do
        TmGrammar::Generator::TextMateGrammar
          .any_instance.should_receive(:generate)

        application.run
      end
    end

    context 'when no format is requested ' do
      it 'instantiates the TmLanguageXml generator' do
        TmGrammar::Generator::TmLanguageXml
          .any_instance.should_receive(:generate)

        application.run
      end
    end

    context 'when the format is invalid' do
      let(:format) { 'foo' }
      let(:raw_args) { super() + ['--format', format] }

      it 'outputs "Invalid argument: --format foo" and exits' do
        application.should_receive(:exit).with(1)
        error_message = "Invalid argument: --format #{format}"
        application.should_receive(:puts).with(error_message)
        application.run
      end
    end

    context 'when no arguments are given' do
      let(:raw_args) { [] }
      let(:usage_info) do
        <<-usage
Usage: tm_grammar [options] <input_file>
Version: 0.0.1

Options:
    -r, --rule <rule>                Only output this rule
    -f, --format <format>            The output form to use(xml, plist)
        --indent <level>             Indentation level used for formatting
        --indent-text <text>         Indentation text used for formatting
    -v, --[no-]verbose               Show verbose output
        --version                    Print version information and exit
    -h, --help                       Show this message and exit

Use the `-h' flag for help.
usage
      end

      it 'outputs the usage information' do
        application.should_receive(:puts).with(usage_info)
        application.run
      end
    end
  end
end
