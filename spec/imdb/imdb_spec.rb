require 'spec_helper'

describe "Imdb" do
  
  it "should report the right version" do
    current_version = File.open(File.join(File.dirname(__FILE__), '..', '..', 'VERSION'), 'r') { |f| f.read.strip }
    Imdb::VERSION.should eql(current_version)
  end
  
end