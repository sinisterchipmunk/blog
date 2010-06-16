module ImagesHelper
  def gravatar_image_path(email = current_user.email)
    api = Gravatar.new(email)
    Rails.cache.write("gravatar_image_path-#{api.email_hash}", api.image_data)
    url_for(:controller => "images", :action => "gravatar", :id => api.email_hash)
  end
end
