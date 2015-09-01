require_relative 'test_helper'

describe "noder command no arguments" do
  before do
    @output = %x{ ./bin/noder }
    @status = $?
  end

  it "should display a usage message" do
    assert @output == "USAGE: noder path/to/wkt\n"
  end

  it "should have exit status 1" do
    assert @status.exitstatus == 1
  end
end

describe "noder command with bad filename" do
  before do
    @output = %x{ ./bin/noder ./does_not_exist.wkt }
    @status = $?
  end

  it "should present error message" do
    assert @output.match /^ERROR:/
  end

  it "should have exit status 2" do
    assert @status.exitstatus == 2
  end
end