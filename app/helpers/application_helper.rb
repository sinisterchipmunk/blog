# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def blog
    #return @blog if @blog
    
    if (@blog_count ||= Blog.count) > 1
      raise "Only expected to find one Blog in the database. Why are there #{@blog_count}?"
    end
    
    @blog ||= Blog.first
    if @blog.nil?
      raise "Blog doesn't seem to exist. Make sure you've seeded the database."
    end
    
    @blog
  end
  
  # Since this produces javascript, passing :encode => :javascript probably won't work.
  # Use :encode => :hex or some such instead.
  def obfuscated_mail_to(email_address, name = nil, html_options = {})
    link_tag = mail_to(email_address, name, html_options)
    javascript_tag <<-end_js
      var _e = '';
      var _a = ['#{link_tag.gsub(/(.{3})/, "','\\1','")}'];
      for (var i = 0; i < _a.length; i++)
        _e += _a[i];
      document.write(_e);
    end_js
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
  
  def plural_or_singular(count, word)
    word = count != 1 ? word.pluralize : word.singularize
    "#{count} #{word}"
  end
end
