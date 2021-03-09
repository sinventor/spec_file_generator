# frozen_string_literal: true

module SpecFileGenerator
  class Service
    class << self
      def call(*args)
        new(*args).call
      end
    end

    def initialize(*); end

    def call; end
  end
end
