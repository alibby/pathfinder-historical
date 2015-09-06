require_relative '../test_helper'

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

describe "noder command with file having unknown extension" do
  before do
    @output = %x{ ./bin/noder ./bad_extension.doc }
    @status = $?
  end

  it "should present an error message" do
    @output.must_match /^ERROR:/
  end

  it "should have exist status 3" do
    @status.exitstatus.must_equal 3
  end
end

describe "noder command with non-existent file" do
  before do
    @output = %x{ ./bin/noder ./does_not_exist.wkt }
    @status = $?
  end

  it "should present error message" do
    assert @output.match /^ERROR:/
  end

  it "should have exit status 2" do
    @status.exitstatus.must_equal 2
  end
end