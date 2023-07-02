# frozen_string_literal: true

require_relative "lib/rubocop/dir_methods/version"

Gem::Specification.new do |spec|
  spec.name          = "rubocop-dir_methods"
  spec.version       = RuboCop::DirMethods::VERSION
  spec.authors       = ["GeorgeGorbanev"]
  spec.email         = ["georgegorbanev@gmail.com"]

  spec.summary       = "Rubocop plugin for enforcing method names in dirs."
  spec.description   = "This gem is a tool designed to extend the functionality of RuboCop." \
                       "It provides single RuboCop/Cop with capability to define and enforce custom naming " \
                       "conventions for public methods within specific directories in your Ruby projects. " \
                       "With this gem, you can maintain consistent coding practices and preserve the " \
                       "integrity of your project's codebase."
  spec.homepage      = "https://github.com/GeorgeGorbanev/rubocop-dir_methods"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubocop"
end
