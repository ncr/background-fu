begin
  require "jeweler"
  Jeweler::Tasks.new do |gem|
    gem.name = "background_fu"
    gem.summary = "Background tasks in Ruby on Rails made dead simple"
    gem.email = "jacek.becela@gmail.com"
    gem.homepage = "http://github.com/ncr/background-fu"
    gem.authors = ["Jacek Becela"]
    gem.files = Dir["*", "{lib}/**/*"]
    gem.add_dependency("daemons", ">= 1.0.10")
    gem.has_rdoc = true
    gem.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end