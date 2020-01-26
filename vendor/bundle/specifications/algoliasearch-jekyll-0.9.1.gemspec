# -*- encoding: utf-8 -*-
# stub: algoliasearch-jekyll 0.9.1 ruby lib

Gem::Specification.new do |s|
  s.name = "algoliasearch-jekyll".freeze
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tim Carry".freeze]
  s.date = "2017-12-21"
  s.description = "[\u26A0 DEPRECATED \u26A0]: Use jekyll-algolia instead".freeze
  s.email = "tim@pixelastic.com".freeze
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.homepage = "https://github.com/algolia/algoliasearch-jekyll".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "  !    The 'algolisearch-jekyll' gem has been deprecated and has been replaced with 'jekyll-algolia'.\n  !    See: https://rubygems.org/gems/jekyll-algolia\n  !    And: https://github.com/algolia/jekyll-algolia\n  !\n  !    You can get quickly started on the new plugin using this documentation:\n  !    https://community.algolia.com/jekyll-algolia/getting-started.html\n".freeze
  s.rubygems_version = "3.0.6".freeze
  s.summary = "[\u26A0 DEPRECATED \u26A0]: Use jekyll-algolia instead".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<algoliasearch>.freeze, ["~> 1.12"])
      s.add_runtime_dependency(%q<appraisal>.freeze, ["~> 2.1.0"])
      s.add_runtime_dependency(%q<awesome_print>.freeze, ["~> 1.6"])
      s.add_runtime_dependency(%q<json>.freeze, [">= 1.8.6"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 1.7.2", "~> 1.7"])
      s.add_runtime_dependency(%q<verbal_expressions>.freeze, ["~> 0.1.5"])
      s.add_development_dependency(%q<rake>.freeze, ["< 11.0"])
      s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<flay>.freeze, ["~> 2.6"])
      s.add_development_dependency(%q<flog>.freeze, ["~> 4.3"])
      s.add_development_dependency(%q<guard-rspec>.freeze, ["~> 4.6"])
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 2.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.31"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.10"])
      s.add_development_dependency(%q<rack>.freeze, ["< 2"])
    else
      s.add_dependency(%q<algoliasearch>.freeze, ["~> 1.12"])
      s.add_dependency(%q<appraisal>.freeze, ["~> 2.1.0"])
      s.add_dependency(%q<awesome_print>.freeze, ["~> 1.6"])
      s.add_dependency(%q<json>.freeze, [">= 1.8.6"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.7.2", "~> 1.7"])
      s.add_dependency(%q<verbal_expressions>.freeze, ["~> 0.1.5"])
      s.add_dependency(%q<rake>.freeze, ["< 11.0"])
      s.add_dependency(%q<coveralls>.freeze, ["~> 0.8"])
      s.add_dependency(%q<flay>.freeze, ["~> 2.6"])
      s.add_dependency(%q<flog>.freeze, ["~> 4.3"])
      s.add_dependency(%q<guard-rspec>.freeze, ["~> 4.6"])
      s.add_dependency(%q<jeweler>.freeze, ["~> 2.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.31"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.10"])
      s.add_dependency(%q<rack>.freeze, ["< 2"])
    end
  else
    s.add_dependency(%q<algoliasearch>.freeze, ["~> 1.12"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 2.1.0"])
    s.add_dependency(%q<awesome_print>.freeze, ["~> 1.6"])
    s.add_dependency(%q<json>.freeze, [">= 1.8.6"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.7.2", "~> 1.7"])
    s.add_dependency(%q<verbal_expressions>.freeze, ["~> 0.1.5"])
    s.add_dependency(%q<rake>.freeze, ["< 11.0"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.8"])
    s.add_dependency(%q<flay>.freeze, ["~> 2.6"])
    s.add_dependency(%q<flog>.freeze, ["~> 4.3"])
    s.add_dependency(%q<guard-rspec>.freeze, ["~> 4.6"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 2.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.31"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.10"])
    s.add_dependency(%q<rack>.freeze, ["< 2"])
  end
end
