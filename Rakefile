require 'rubygems'
require 'hoe'
require './lib/background_fu.rb'

Hoe.new('background-fu', BackgroundFu::VERSION) do |p|
  p.rubyforge_name = 'background-fu'
  p.developer('Jacek Becela', 'jacek.becela@gmail.com')
end

desc 'Test the background-fu plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
