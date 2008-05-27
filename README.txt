= BackgroundFu

* http://github.com/ncr/background-fu
* git://github.com/ncr/background-fu.git
* http://trix.lighthouseapp.com/projects/9809-backgroundfu
* ncr@trix.pl
* http://trix.pl

== DESCRIPTION:

Background tasks in Ruby On Rails made dead simple.

== FEATURES/PROBLEMS:

* Running long background tasks outside of request-response cycle.
* Very easy to setup and fun to use (See examples below). 
* Clean and straightforward approach (database-based priority queue).
* Uses database table (migration included) to store jobs reliably.
* Capistrano tasks included. 
* Generators with migrations and example views included.
* Multiple worker daemons available.
* Easy to deploy in distributed environments.
* Enables prioritizing and simple scheduling.
* Optional worker monitoring (good for AJAX progress bars).
* Proven its stability and reliability in production use.

== SYNOPSIS:

  ./script/plugin install git://github.com/ncr/background-fu.git

  ruby ./script/generate background
  rake db:migrate
  
  # to run in production mode use RAILS_ENV=production ruby ./script/daemons start
  ruby ./script/daemons start

  # then try in console:
    
  job_id = Job.enqueue!(ExampleWorker, :add, 1, 2).id

  # after few seconds when background daemon completes the job

  Job.find(job_id).result # result of the job should equal 3

== EXAMPLES:

  # In lib/workers/example_worker.rb:

  # Simple, non-monitored worker.
  class ExampleWorker
  
    def add(a, b)
      a + b
    end

  end

  # In lib/workers/example_monitored_worker.rb:

  # Remeber to include BackgroundFu::WorkerMonitoring.
  class ExampleMonitoredWorker

    include BackgroundFu::WorkerMonitoring
  
    def long_and_monitored
      my_progress = 0
    
      record_progress(my_progress)

      while(my_progress < 100)
        my_progress += 1
        record_progress(my_progress)
        sleep 1
      end
    
      record_progress(100)
    end
  
  end

  # In a controller:

    def create
      session[:job_id] = Job.enqueue!(ExampleWorker, :add, 1, 2).id
      # or try the monitored worker: session[:job_id] = Job.enqueue!(ExampleMonitoredWorker, :long_and_monitored)
    end

    def show
      @job    = Job.find(session[:job_id])
      @result = @job.result if @job.finished?
      # or check progress if your worker is monitored: @progress = @job.progress
    end
  
    def index
      @jobs = Job.find(:all)
    end
  
    def destroy
      Job.find(session[:job_id]).destroy
    end

== HANDY CAPISTRANO TASKS:

  namespace :deploy do

    desc "Run this after every successful deployment" 
    task :after_default do
      restart_background_fu
    end

  end

  desc "Restart BackgroundFu daemon"
  task :restart_background_fu do
    run "RAILS_ENV=production ruby #{current_path}/script/daemons stop"
    run "RAILS_ENV=production ruby #{current_path}/script/daemons start"
  end
  
== BONUS FEATURES:

There are bonus features available if you set
ActiveRecord::Base.allow_concurrency = true 
in your environment.

These features are: 
 * monitoring progress (perfect for ajax progress bars)
 * stopping a running worker in a merciful way.

Read the code (short and easy) to discover them.

== REQUIREMENTS:

* rails
* daemons

== INSTALL:

* FIX (sudo gem install, anything else)

== CONTRIBUTING:

If you want to help improve this plugin, feel free to contact me. Fork the project on GitHub, implement a feature, send me a pull request.

== LICENSE:

(The MIT License)

Copyright (c) Jacek Becela

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
