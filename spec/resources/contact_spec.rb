require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActsAsIcontact::Contact do
  it "defaults to a limit of 500"
  it "defaults to searching on all contacts regardless of list status"
  it "throws an exception if a limit higher than 500 is attempted"
  
end