require 'spec_helper'

describe TmGrammar::RSpec::Matchers::BeParsedAs do
  let(:scope) { 'scope' }
  let(:code_extract) { 'code_extract' }

  let(:matcher) do
    TmGrammar::RSpec::Matchers::BeParsedAs.new(scope)
  end

  def xml(content)
    content.split("\n").map(&:strip).join('')
  end

  before :each do
    matcher.send(:code_extract=, code_extract)
  end

  describe 'extract_result' do
    def extract_result!
      matcher.send(:extract_result, gtm_result)
    end

    context 'when extracting partial code' do
      let(:scope) { 'support.other.double-quoted-character.d' }
      let(:code_extract) { 'asd' }

      let(:gtm_result) do
        xml <<-XML
          <unscoped>
            <support.other.double-quoted-characters.d>
              <support.other.double-quoted-character.d>
                foo
                <constant.char.escape.d>\v</constant.char.escape.d>
                bar
                <constant.char.escape.d>\UC135a603</constant.char.escape.d>
                #{code_extract}
              </support.other.double-quoted-character.d>
            </support.other.double-quoted-characters.d>
          </unscoped>
        XML
      end

      it 'extracts the scope' do
        parsed_scope, = extract_result!
        parsed_scope.should == scope
      end

      it 'extracts the code' do
        _, parsed_code_extract = extract_result!
        parsed_code_extract.should == code_extract
      end
    end

    context 'when extracting unmatching result' do
      let(:scope) { 'unscoped' }
      let(:code_extract) { '`foo\nbar`' }

      let(:gtm_result) do
        xml <<-XML
          <unscoped>
            <string.quoted.other.alternate-wysiwyg.d>
              <punctuation.definition.string.begin.d>
                `
              </punctuation.definition.string.begin.d>
              foo\\nbar
              <punctuation.definition.string.end.d>
                `
              </punctuation.definition.string.end.d>
            </string.quoted.other.alternate-wysiwyg.d>
          </unscope
        XML
      end

      it 'extracts the scope' do
        parsed_scope, = extract_result!
        parsed_scope.should == scope
      end

      it 'extracts the code' do
        _, parsed_code_extract = extract_result!
        parsed_code_extract.should == code_extract
      end
    end
  end
end
