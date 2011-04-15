require 'rubygems'
require 'rspec'
require 'rspec/core/rake_task'
require 'bundler'
Bundler::GemHelper.install_tasks

namespace :spec do
  desc 'Run specs'
  RSpec::Core::RakeTask.new(:run) do |spec|
    spec.rspec_opts = ['--options', 'spec/spec.opts'] if File.exists?('spec/spec.opts')
    spec.pattern = 'spec/**/*_spec.rb'
  end

  desc 'Specs with rcov'
  RSpec::Core::RakeTask.new(:rcov) do |spec|
    spec.rspec_opts = ['--options', 'spec/spec.opts'] if File.exists?('spec/spec.opts')
    spec.pattern = 'spec/**/*_spec.rb'

    begin
      spec.rcov = true
      spec.rcov_opts << '--exclude' << 'spec'
    rescue Exception => e
      puts e
    end
  end
end

desc 'Run specs'
task :spec => 'spec:run'
