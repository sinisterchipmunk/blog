class ImagesController < ApplicationController
  def gravatar
    key = "gravatar_image_path-#{params[:id]}"
    send_data Rails.cache.read(key).to_s, :disposition => "inline", :filename => "#{key}.jpg", :type => "image/jpg"
  end
end
