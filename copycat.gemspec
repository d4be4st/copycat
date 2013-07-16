$:.push File.expand_path("../lib", __FILE__)

require "copycat/version"

Gem::Specification.new do |s|
  s.name        = "copycat"
  s.version     = Copycat::VERSION
  s.authors     = ["Andrew Ross", "Steve Masterman", "Zorros"]
  s.email       = ["info@vermonster.com"]
  s.homepage    = "https://github.com/Zorros/copycat"
  s.summary     = "Rails engine for editing live website copy."
  s.description = "Edit live website copy."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency(%q<rails>, [">= 4.0.0"])
  s.add_dependency(%q<haml-rails>)
end
