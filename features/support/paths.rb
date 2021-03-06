module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      root_path
    when /the categories page/
      categories_path
    when /the new post page/
      new_post_path
    when /the published post page/
      post_path(Post.first)  
    when /the login page/, /the sign\s?in page/, /the new user session page/
      new_user_session_path
    when /the post comments page/
      post_comments_path(Post.first)  
    
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
