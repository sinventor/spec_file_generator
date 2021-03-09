# frozen_string_literal: true

require "fileutils"
require "facets/string/pathize"
require "facets/string/snakecase"

module SpecFileGenerator
  class FileBuilder < Service
    def initialize(klass, config = OpenStruct.new)
      @klass = klass
      @config = config
    end

    def call
      create_folder unless Dir.exist?(spec_folder_to_write)
      File.write(file_to_write, placeholder)
      file_to_write
    end

    private

    def path_without_extension
      @klass.pathize.snakecase
    end

    def spec_folder_to_write
      @spec_folder_to_write ||= File.join(place_into, path_without_extension.split("/")[0..-2])
    end

    def file_to_write
      File.join(place_into, "#{path_without_extension}_spec.rb")
    end

    def create_folder
      FileUtils.mkdir_p(spec_folder_to_write)
    end

    def place_into
      @place_into ||= @config.place_into || "spec"
    end

    def placeholder
      <<~TEMPLATE
        # frozen_string_literal: true

        require 'spec_helper'

        RSpec.describe #{@klass} do
        end
      TEMPLATE
    end
  end
end
