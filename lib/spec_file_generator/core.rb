# frozen_string_literal: true

require "ostruct"
require "tty/logger"

module SpecFileGenerator
  class Core < Service
    def initialize(source_file, config = OpenStruct.new)
      @source_file = source_file
      @config = config
      @logger = TTY::Logger.new
    end

    def call
      generated_spec_file = FileBuilder.call(KlassExtractor.call(@source_file), @config)
      @logger.success "Spec file has been successfully generated at #{generated_spec_file}."
    rescue StandardError => e
      @logger.error "[#{e.class}]: #{e}"
    end
  end
end
