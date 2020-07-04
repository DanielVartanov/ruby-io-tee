require_relative 'lib/io/tee/version'

Gem::Specification.new do |spec|
  spec.name          = "io-tee"
  spec.version       = IO::Tee::VERSION
  spec.authors       = ["Daniel Vartanov"]
  spec.email         = ["dan@vartanov.net"]

  spec.summary       = %q{Copies stdout (or any other IO stream) contents to a file or another stream. Works with subprocesses too.}
  spec.homepage      = "https://github.com/DanielVartanov/ruby-io-tee"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/DanielVartanov/ruby-io-tee"
  spec.license = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rspec'
end
