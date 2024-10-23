require_relative "lib/mapkick/version"

Gem::Specification.new do |spec|
  spec.name          = "mapkick-rb"
  spec.version       = Mapkick::VERSION
  spec.summary       = "Create beautiful JavaScript maps with one line of Ruby"
  spec.homepage      = "https://chartkick.com/mapkick"
  spec.license       = "MIT"

  spec.author        = "Andrew Kane"
  spec.email         = "andrew@ankane.org"

  spec.files         = Dir["*.{md,txt}", "{lib,licenses,vendor}/**/*"]
  spec.require_path  = "lib"

  spec.required_ruby_version = ">= 3.1"
end
