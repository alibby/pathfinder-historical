
require 'rake/testtask'
require 'rake/clean'

CLEAN.include(FileList["tmp/test_*"])

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList[%w(test/**/*_test.rb test/**/*_spec.rb)]
  t.verbose = true
end
