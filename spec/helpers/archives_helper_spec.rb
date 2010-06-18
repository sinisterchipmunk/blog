require 'spec_helper'

describe ArchivesHelper do
  before(:all) do
    for year in 2001..2010
      for month in 1..12
        date_str = "#{month}/#{rand(25)+1}/#{year}"
        publish_date = Date.parse(date_str)
        Post.create!(:publish_date => publish_date, :title => "Post on #{publish_date}")
      end
    end
  end
  
  after(:all) do
    Post.destroy_all
  end
  
  it "should retrieve years of all archives" do
    helper.archive_years.should == (2001..2010).to_a.reverse # because we start with the most recent date
  end
  
  it "should retrieve months of archives for a particular year" do
    helper.archive_months(2001).collect { |m| m.strftime("%B") } \
      .should == %w(December November October September August July June May April March February January)
  end
end