# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def blog
    return @blog if @blog
    
    if (@blog_count ||= Blog.count) > 1
      raise "Only expected to find one Blog in the database. Why are there #{@blog_count}?"
    end
    
    @blog ||= Blog.first
    if @blog.nil?
      raise "Blog doesn't seem to exist. Make sure you've seeded the database."
    end
    @blog
  end
  
  def tweetbacks?
    !defined?(@tweetbacks) || @tweetbacks
  end
  
  def content_given?(symbol)
    content_var_name="@content_for_" +
      if symbol.kind_of? Symbol then symbol.to_s
      elsif symbol.kind_of? String then symbol
      else raise "Parameter symbol must be string or symbol"
      end
    !instance_variable_get(content_var_name).nil?
  end
end
