lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "callgraphy/version"

Gem::Specification.new do |spec|
  spec.name          = "callgraphy"
  spec.version       = Callgraphy::VERSION
  spec.authors       = ["Alistair McKinnell"]
  spec.email         = ["alistair.mckinnell@gmail.com"]

  spec.summary       = "A command line tool for creating a call graph for a target class."
  spec.homepage      = "https://github.com/amckinnell/callgraphy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.1"

  spec.add_runtime_dependency "ruby-graphviz", "~> 1.2", ">= 1.2.0"

  spec.add_development_dependency "bundler", "~> 1.13", ">= 1.13.0"
  spec.add_development_dependency "mutant-rspec", "~> 0.8.0"
  spec.add_development_dependency "rake", "~> 11.1", ">= 11.1.0"
  spec.add_development_dependency "rspec", "~> 3.5", ">= 3.5.0"
  spec.add_development_dependency "rubocop", "~> 0.47.0"
  spec.add_development_dependency "simplecov", "~> 0.12.0"
end
