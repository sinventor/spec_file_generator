# frozen_string_literal: true

require "spec_helper"

RSpec.describe SpecFileGenerator::Service do
  describe ".call" do
    let(:service_mock) { instance_double(described_class, call: nil) }
    let(:argument) { "foo" }

    it "creates a new instance and calls the #call" do
      allow(described_class).to receive(:new).and_return(service_mock)

      described_class.call(argument)

      expect(described_class).to have_received(:new).with(argument)
      expect(service_mock).to have_received(:call)
    end
  end
end
