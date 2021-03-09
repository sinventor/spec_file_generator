# frozen_string_literal: true

require "parser/current"

module SpecFileGenerator
  class KlassExtractor < Service
    def initialize(source_file)
      @source_file = source_file
    end

    def call
      ensure_source_file_exist!

      @module_acc = []
      @spec_name = nil
      look_for_class(ast)

      return @spec_name unless @spec_name.nil?

      raise ClassDeclarationMissingError,
            "Please check content of source file (#{@source_file}). " \
            "Class declaration must present in order to generate spec file."
    end

    private

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
    def look_for_class(ast)
      return unless ast.is_a?(Parser::AST::Node) && @spec_name.nil?

      case ast.type
      when :module
        @module_acc.push(ast.to_sexp_array[1].last.to_s)
        ast.children.map(&method(:look_for_class))
      when :class
        module_names = @module_acc.empty? ? "" : "#{@module_acc.join("::")}::"
        @spec_name = module_names + ast.to_sexp_array[1].last.to_s
      when :begin
        ast.children.map(&method(:look_for_class))
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity

    def ast
      Parser::CurrentRuby.parse(File.read(@source_file))
    rescue Parser::SyntaxError => e
      raise SpecFileGenerator::SyntaxError,
            "Please check content of source file (#{@source_file}). " \
            "It seems to have incorrect ruby syntax:\n#{e}"
    end

    def ensure_source_file_exist!
      raise IncorrectSourceFileError, @source_file unless File.file?(@source_file)
    end
  end
end
