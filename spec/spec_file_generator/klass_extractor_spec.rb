# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpecFileGenerator::KlassExtractor do
  let(:existing_ruby_file) { "foo/bar/baz.rb" }
  let(:klass_extractor) { described_class.new(existing_ruby_file) }

  let(:file_content) do
    <<~CONTENT
      module Foo
        module Bar
          class Baz
            def do_someting
            end
          end
        end
      end
    CONTENT
  end

  before do
    allow(File).to receive(:read).and_return(file_content)
    allow(File).to receive(:file?).and_return(true)
  end

  describe ".call" do
    context "when file content have syntax errors" do
      let(:file_content) do
        <<~CONTENT
          module Foo
            module Bar
              oops Baz
                def do_someting
                end
              end
            end
          end
        CONTENT
      end

      it "raises SyntaxError exception" do
        expect { klass_extractor.call }.to raise_error(
          SpecFileGenerator::SyntaxError,
          "Please check content of source file (#{existing_ruby_file}). " \
          "It seems to have incorrect ruby syntax:\nunexpected token kEND"
        )
      end
    end

    context "when file content have no class declaration" do
      let(:file_content) do
        <<~CONTENT
          FOO = 'Bar'
        CONTENT
      end

      it "raises ClassDeclarationMissingError" do
        expect { klass_extractor.call }.to raise_error(
          SpecFileGenerator::ClassDeclarationMissingError,
          "Please check content of source file (#{existing_ruby_file}). " \
          "Class declaration must present in order to generate spec file."
        )
      end
    end

    it "returns a class parsed by ast" do
      expect(klass_extractor.call).to eq "Foo::Bar::Baz"
    end
  end
end
