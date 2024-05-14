# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubiod/version"

Gem::Specification.new do |spec|
  spec.name = "rubiod"
  spec.version = Rubiod::VERSION
  spec.authors = ['Eugen "netoctone" Okhrimenko', "McBen"]
  spec.email = ["netoctone@gmail.com"]

  spec.summary = "Work with OpenDocument."
  spec.description = "RubiOD is intended to provide cute interface " \
  "to work with OASIS Open Document Format files. " \
  "It relies on libxml-ruby."
  spec.homepage = "http://github.com/netoctone/rubiod"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir["lib/**/*.rb"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_path = ["lib"]

  spec.required_ruby_version = ">= 3.0"
  spec.required_rubygems_version = ">= 2.0"

  spec.add_development_dependency "bundler", "~> 2.5"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "nokogiri", "~> 1.16"
  spec.add_dependency "rubyzip", "~> 2.3.0"
end
