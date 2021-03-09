# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpecFileGenerator::Core do
  let(:existing_ruby_file) { "foo/bar/baz.rb" }
  let(:expected_klass) { "Foo::Bar::Baz" }
  let(:null_logger) do
    TTY::Logger.new do |config|
      config.handlers = [:null]
    end
  end

  describe ".call" do
    before do
      allow(TTY::Logger).to receive(:new).and_return(null_logger)
    end

    context "when config does not specified" do
      it "calls a chain of KlassExtractor and FileBuilder processors with default config" do
        allow(SFG::KlassExtractor).to receive(:call).with(existing_ruby_file).and_return(expected_klass)
        allow(SFG::FileBuilder).to receive(:call).with(expected_klass, OpenStruct.new)

        described_class.call(existing_ruby_file)

        expect(SFG::KlassExtractor).to have_received(:call).with(existing_ruby_file)
        expect(SFG::FileBuilder).to have_received(:call).with(expected_klass, OpenStruct.new)
      end
    end

    context "when config is specified" do
      let(:config) { OpenStruct.new(place_into: File.join("custom", "folder")) }

      before do
        allow(SFG::KlassExtractor).to receive(:call).with(existing_ruby_file).and_return(expected_klass)
        allow(SFG::FileBuilder).to receive(:call).with(expected_klass, config)
      end

      it "calls a chain of KlassExtractor and FileBuilder processors with specified config" do
        described_class.call(existing_ruby_file, config)

        expect(SFG::KlassExtractor).to have_received(:call).with(existing_ruby_file)
        expect(SFG::FileBuilder).to have_received(:call).with(expected_klass, config)
      end

      # rubocop:disable RSpec/NestedGroups
      describe "logging" do
        let(:tty_logger_mock) { instance_double(TTY::Logger, success: nil, error: nil) }

        before do
          allow(TTY::Logger).to receive(:new).and_return(tty_logger_mock)
        end

        # rubocop:disable RSpec/MultipleMemoizedHelpers
        context "when operation is succeeded" do
          let(:generated_spec_file) { "path/to/file_spec.rb" }
          let(:success_message) { "Spec file has been successfully generated at #{generated_spec_file}." }

          it "logs success message" do
            allow(SFG::KlassExtractor).to receive(:call).with(existing_ruby_file).and_return(expected_klass)
            allow(SFG::FileBuilder).to receive(:call).with(expected_klass, config).and_return(generated_spec_file)
            described_class.call(existing_ruby_file, config)
            expect(tty_logger_mock).to have_received(:success).with(success_message)
          end
        end
        # rubocop:enable RSpec/MultipleMemoizedHelpers

        context "when operation is failed" do
          let(:error) do
            {
              klass: StandardError,
              message: "oops"
            }
          end

          it "logs error message" do
            allow(SFG::KlassExtractor).to receive(:call).and_raise(error[:klass], error[:message])
            described_class.call(existing_ruby_file, config)
            expect(tty_logger_mock).to have_received(:error).with("[#{error[:klass]}]: #{error[:message]}")
          end
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
