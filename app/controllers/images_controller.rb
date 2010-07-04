class ImagesController < ApplicationController
  def gravatar
    key = "gravatar_image_path-#{params[:id]}"
    send_data Rails.cache.read(key).to_s, :disposition => "inline", :filename => "#{key}.jpg", :type => "image/jpg"
  end
  
  def show
    if params[:id]
      data = cached_image(params[:id]) do
        id = params[:id].gsub(/^([0-9]+)(\-.*$)/, '\1')
        image = Image.find(id)
        { :data => image.data, :filename => image.name, :content_type => image.content_type }
      end
      
      send_data data[:data], :disposition => 'inline', :filename => data[:filename], :type => data[:content_type]
    else
      render :text => "ID expected"
    end
  end
  
  private
  def cached_image(key)
    if data = Rails.cache.read(key)
      return data
    else
      data = yield
      Rails.cache.write(key, data)
      data
    end
  end
end
