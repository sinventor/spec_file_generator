# frozen_string_literal: true

module SpecFileGenerator
  class SyntaxError < StandardError; end

  class ClassDeclarationMissingError < StandardError; end

  class IncorrectSourceFileError < StandardError
    def initialize(source_file)
      super("No such file - #{source_file}.")
    end
  end
end
