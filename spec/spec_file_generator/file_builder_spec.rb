# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpecFileGenerator::FileBuilder do
  let(:klass) { "Foo::Bar::Baz" }
  let(:spec_folder_exists) { true }
  let(:expected_spec_folder) { File.join("spec", "foo", "bar") }
  let(:expected_spec_file) { File.join("spec", "foo", "bar", "baz_spec.rb") }
  let(:expected_file_content) do
    <<~TEMPLATE
      # frozen_string_literal: true

      require 'spec_helper'

      RSpec.describe #{klass} do
      end
    TEMPLATE
  end

  before do
    allow(File).to receive(:write)
    allow(Dir).to receive(:exist?).and_return(spec_folder_exists)
  end

  describe ".call" do
    context "when appropriate spec folder does not exist" do
      let(:spec_folder_exists) { false }

      it "creates a nested spec folder and writes template spec for a class" do
        allow(FileUtils).to receive(:mkdir_p).with(expected_spec_folder)
        described_class.call(klass)
        expect(FileUtils).to have_received(:mkdir_p).with(expected_spec_folder)
        expect(File).to have_received(:write).with(expected_spec_file, expected_file_content)
      end
    end

    context "when place_into option is specified" do
      let(:config) do
        OpenStruct.new(place_into: File.join("some", "custom", "spec", "folder"))
      end
      let(:expected_spec_file) { File.join(config.place_into, "foo", "bar", "baz_spec.rb") }

      it "creates a folder pointed by place_into config and writes template spec for a class" do
        described_class.call(klass, config)

        expect(File).to have_received(:write).with(expected_spec_file, expected_file_content)
      end
    end

    context "when appropriate spec folder already exists" do
      it "writes template spec for a class" do
        allow(FileUtils).to receive(:mkdir_p)

        described_class.new(klass).call

        expect(FileUtils).not_to have_received(:mkdir_p)
        expect(File).to have_received(:write).with(expected_spec_file, expected_file_content)
      end
    end
  end
end
