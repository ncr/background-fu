Gem::Specification.new do |s|
  s.name = %q{background_fu}
  s.version = "1.0.10"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacek Becela"]
  s.date = %q{2009-02-07}
  s.description = %q{Background tasks in Ruby On Rails made dead simple.}
  s.email = ["jacek.becela@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "background-fu.gemspec", "generators/background/USAGE", "generators/background/background_generator.rb", "generators/background/templates/background.rb", "generators/background/templates/background_ctl", "generators/background/templates/daemons", "generators/background/templates/daemons.yml", "generators/background/templates/example_monitored_worker.rb", "generators/background/templates/example_worker.rb", "generators/background/templates/migration.rb", "generators/background/templates/scaffold/_form.html.erb", "generators/background/templates/scaffold/_job.html.erb", "generators/background/templates/scaffold/_job_deleted.html.erb", "generators/background/templates/scaffold/_progress_indicator.html.erb", "generators/background/templates/scaffold/application_controller.rb", "generators/background/templates/scaffold/background_fu.css", "generators/background/templates/scaffold/index.html.erb", "generators/background/templates/scaffold/jobs.html.erb", "generators/background/templates/scaffold/jobs_controller.rb", "generators/background/templates/scaffold/jobs_helper.rb", "generators/background/templates/scaffold/new.html.erb", "lib/background_fu.rb", "lib/background_fu/worker_monitoring.rb", "lib/job.rb", "lib/job/bonus_features.rb", "rails/init.rb", "test/job_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/ncr/background-fu}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{background-fu}
  s.rubygems_version = %q{1.1.1}
  s.summary = %q{Background tasks in Ruby On Rails made dead simple.}

  s.add_dependency(%q<daemons>, [">= 1.0.10"])
end
