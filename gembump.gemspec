require "date"
Gem::Specification.new do |s|
  s.name = "gembump"
  s.version = "0.1.2"
  s.date = Date.today.strftime("%Y-%m-%d")
  s.summary = "Rubygems plugin to bump versioning automatically."
  s.description = "Rubygems plugin that allows you to bump the major, minor, and patch version of your gem without editing the gemspec."
  s.homepage = "https://github.com/KellenWatt/gempbump"
  s.authors = ["Kellen Watt"]

  s.files = [
    "lib/rubygems_plugin.rb",
    "lib/rubygems/commands/bump_command.rb",
  ]

  s.license = "MIT"
end
