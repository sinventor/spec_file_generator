# frozen_string_literal: true

require_relative "lib/spec_file_generator/version"

Gem::Specification.new do |spec|
  spec.name          = "spec_file_generator"
  spec.version       = SpecFileGenerator::VERSION
  spec.authors       = "Rushan Alyautdinov"
  spec.email         = "rushan_oline@mail.ru"

  spec.summary       = "Generate spec test for a ruby class."
  spec.description   = "Command line utility to create spec file based on ruby class file."
  spec.homepage      = "https://github.com/sinventor/spec_file_generator"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sinventor/spec_file_generator"
  spec.metadata["changelog_uri"] = "https://github.com/sinventor/spec_file_generator/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "facets", "~> 3.1"
  spec.add_dependency "parser", "~> 3.0"
  spec.add_dependency "slop", "~> 4.8"
  spec.add_dependency "tty-logger", "~> 0.6"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
end
