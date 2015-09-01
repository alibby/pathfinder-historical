require_relative 'test_helper'

describe 'pathfinder command with no arguments' do
  before do
    skip "Still working on pathfinder cli"
    @output = %x{ ./bin/pathfinder }
    @status = $?
  end

  it "should exit with an error message" do
    skip "Still working on pathfinder cli"
    p "x" * 50
    p @output
    p "x" * 50
    assert @output.match(/^ERROR:.*/), "Should show and error message, instead got: '#{@output}'"
  end

  it "should exit with exit code 1" do
    skip "still working on pathfinder cli"
    assert @status.exitstatus == 1, "Exited with exit code #{@status.exitstatus}"
  end
end