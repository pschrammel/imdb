Gem::Specification.new do |s|
  s.name = %q{imdb}
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ariejan de Vroom"]
  s.date = %q{2011-06-17}
  s.default_executable = %q{imdb}
  s.description = %q{Easily use Ruby or the command line to find information on IMDB.com.}
  s.email = %q{peter.schrammel@gmx.de}
  s.executables = ["imdb"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.homepage = %q{http://github.com/pschrammel/imdb}
  s.summary = %q{IMDB scraping library.}


  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake"

  s.add_development_dependency(%q<fakeweb>, ["= 1.3.0"])
  s.add_development_dependency(%q<rspec>, ["= 2.8.0"])
#  s.add_development_dependency(%q<jeweler>, ["= 1.6.2"])

  s.add_runtime_dependency(%q<hpricot>, [">= 0.8.1"])
end

