# encoding: utf-8
$:.push File.expand_path( "../lib", __FILE__ )
require "chrno_responder/version"

Gem::Specification.new do |s|
  s.name        = "chrno_responder"
  s.version     = ChrnoResponder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ "Denis Diachkov" ]
  s.email       = [ "d.diachkov@gmail.com" ]
  s.homepage    = "http://larkit.ru"
  s.summary     = "Extended responder for ActionController"

  s.files         = Dir[ "*", "lib/**/*" ]
  s.require_paths = [ "lib" ]

  s.add_runtime_dependency "rails", ">= 3.0"
end