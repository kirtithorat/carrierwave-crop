# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/crop/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-crop"
  spec.version       = CarrierWave::Crop::VERSION
  spec.authors       = ["Kirti Thorat"]
  spec.email         = ["kirti.brenz@gmail.com"]
  spec.summary       = %q{CarrierWave extension for cropping images with preview.}
  spec.description   = %q{CarrierWave extension to crop uploaded images using Jcrop plugin.}
  spec.homepage      = "https://github.com/kirtithorat/carrierwave-crop"
  spec.license       = "MIT"

  spec.files        = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 3.2"
  spec.add_dependency "jquery-rails"
  spec.add_dependency "carrierwave", [">= 0.8.0", "< 0.11.0"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec" 
end
