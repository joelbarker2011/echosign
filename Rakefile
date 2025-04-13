require "bundler/gem_tasks"

require 'rspec/core/rake_task'
require 'bundler/gem_tasks'

# Default directory to look in is `/specs`
# Run with `rake spec`
RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = [
    '--color',
    '--format', 'documentation',
    '--format', 'RspecJunitFormatter',
    '--out', 'test-results/rspec/results.xml',
    '--fail-fast'
  ]
end

task default: :spec
