# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "march/version"

Gem::Specification.new do |s|
  s.name        = "march"
  s.version     = March::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andreas Alin"]
  s.email       = ["andreas.alin@gmail.com"]
  s.homepage    = "http://github.org/aalin/march"
  s.summary     = %q{Music theory and generated music.}
  s.description = %q{This thing implements some music theory and experiments with generating music.}

  s.files         = Dir["{lib,demos}/**/*"] + %w(Gemfile march.gemspec README.md Rakefile)
  s.test_files    = Dir["spec/**/*"]
end
