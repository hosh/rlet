Gem::Specification.new do |s|
  s.name        = "rlet"
  s.version     = "0.5.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ho-Sheng Hsiao"]
  s.email       = ["hosh@opscode.com"]
  s.homepage    = "http://github.com/hosh/rlet"
  s.summary     = "Class-based scoping with let()"
  s.description = "Class-based scoping with let(). Use rspec's let() outside of rspec"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rlet"

  #s.add_development_dependency "rspec"

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE.txt README.md)
  s.executables  = []
  s.require_path = 'lib'
end
