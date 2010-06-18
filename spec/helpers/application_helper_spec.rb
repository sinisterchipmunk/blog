require 'spec_helper'

describe ApplicationHelper do
  it "should pluralize words that correlate to a count <> 1" do
    helper.plural_or_singular(2, "comment").should == "2 comments"
    helper.plural_or_singular(0, "comment").should == "0 comments"
  end

  it "should pluralize words that correlate to a count == 1" do
    helper.plural_or_singular(1, "comment").should == "1 comment"
  end
end
