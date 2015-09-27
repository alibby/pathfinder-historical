require_relative '../test_helper'
require 'open3'

describe 'pathfinder command with no arguments' do
  before do
    cmd = './bin/pathfinder'
    Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
      @stdout = stdout.read
      @stderr = stderr.read
      @status = wait_thr.value
    end
  end

  it "should exit with an error message" do
    @stdout.must_be :empty?
    @stderr.wont_be :empty?
    @status.exitstatus.must_equal 1
  end
end