require File.dirname(__FILE__) + '/../rspec/lib/spec/rake/spectask'

desc "Run all plugin specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end