# This can fail during migrations, so let's fail silently instead.
begin
  all_posts = Category.find_by_name("All Posts")
  if all_posts.nil?
    Category.create(:name => "All Posts", :hidden => true)
  else
    all_posts.update_attribute(:hidden, true)
  end

  drafts = Category.find_by_name("Drafts")
  if drafts.nil?
    Category.create(:name => "Drafts", :hidden => true)
  else
    drafts.update_attribute(:hidden, true)
  end
rescue NoMethodError
end
