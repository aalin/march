require 'rubygems'
require 'spec'
require 'spec/rake/spectask'

namespace :spec do
	desc 'Run specs'
	Spec::Rake::SpecTask.new(:run) do |t|
		t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
		t.spec_files = Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb'))
	end

	desc 'Specs with rcov'
	Spec::Rake::SpecTask.new(:rcov) do |t|
		t.spec_opts << '--options' << 'spec/spec.opts' if File.exists?('spec/spec.opts')
		t.spec_files = Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb'))

		begin
			t.rcov = ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true
			t.rcov_opts << '--exclude' << 'spec'
			t.rcov_opts << '--text-summary'
			t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
		rescue Exception => e
			puts e
		end
	end
end

desc 'Run specs'
task :spec => 'spec:run'

