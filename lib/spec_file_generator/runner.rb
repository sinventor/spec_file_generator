# frozen_string_literal: true

require "slop"

module SpecFileGenerator
  class Runner
    def run
      config = OpenStruct.new(opts.to_hash.slice(:place_into))
      SpecFileGenerator::Core.call(opts[:source], config)
    rescue Slop::MissingRequiredOption => e
      TTY::Logger.new.error "Please provide all required arguments: #{e}"
    end

    # rubocop:disable Metrics/MethodLength
    def opts
      Slop.parse do |o|
        o.string "-s", "--source", "source file for which spec should be generated", required: true
        o.string "-p", "--place-into", "directory path where generated spec file needs to be placed"
        o.on "-v", "--version", "print the version" do
          puts SpecFileGenerator::VERSION
          exit
        end

        o.on "-h", "--help", "print help message" do
          puts <<~USAGE
            Usage: spec_file_generator [flags]

            Generates spec test for a ruby class for specified source file.

            Flags:

              -s, --source (required) source file for which spec should be generated
              -p, --place-into        directory path where generated spec file needs to be placed
              -v, --version           output the version number
              -h, --help              output usage information
          USAGE
          exit
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
