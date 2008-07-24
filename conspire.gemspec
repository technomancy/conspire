Gem::Specification.new do |s|
  s.name = %q{conspire}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Phil Hagelberg"]
  s.date = %q{2008-07-24}
  s.default_executable = %q{conspire}
  s.email = ["technomancy@gmail.com"]
  s.executables = ["conspire"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["COPYING", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "bin/conspire", "lib/conspire.rb", "lib/conspire/conspirator.rb", "lib/conspire/gitjour_exts.rb", "lib/conspire/support/conspire.el", "test/test_conspire.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://bus-scheme.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{conspire}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Conspire is a real-time collaborative editing platform using Git as a transport layer.}
  s.test_files = ["test/test_conspire.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gitjour>, ["= 6.3.0"])
      s.add_runtime_dependency(%q<clip>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.7.0"])
    else
      s.add_dependency(%q<gitjour>, ["= 6.3.0"])
      s.add_dependency(%q<clip>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.7.0"])
    end
  else
    s.add_dependency(%q<gitjour>, ["= 6.3.0"])
    s.add_dependency(%q<clip>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.7.0"])
  end
end