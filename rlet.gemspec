# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rlet/version'

Gem::Specification.new do |s|
  s.name        = "rlet"
  s.version     = RLet::VERSION
  s.authors     = ["Ho-Sheng Hsiao"]
  s.email       = ["talktohosh@gmail.com"]
  s.homepage    = "http://github.com/hosh/rlet"
  s.summary     = "Lazy-eval and functional helpers"
  s.description = "Use rspec's let() outside of rspec with concerns and functional operators"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rlet"

  s.add_development_dependency "rspec"

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE.txt README.md)
  s.executables  = []
  s.require_path = 'lib'
end
