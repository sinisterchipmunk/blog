class ImagesController < ApplicationController
  require_login_for :index, :create
  
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
  
  def create
    url = params[:image][:url]
    filename = params[:image][:filename]
    filename = nil if filename.blank?
    
    if params[:image][:file]
      image_name = filename || params[:image][:file].original_filename
      
      data = params[:image][:file].read
      content_type = params[:image][:file].content_type
    else
      image_name = filename || url
      
      response = Net::HTTP.get_response(URI.parse(url))
      data = response.body
      content_type = response['Content-type']
    end
    
    image_name = image_name.gsub(/^.*(\/|\\)([^\/\\]+)$/, '\2')
    image_name = image_name[0...image_name.index(?.)] if image_name['.'] # lose the extension, if any
    image_name = 'no-name' if image_name.blank?
    @image = Image.new(:name => image_name, :data => data, :content_type => content_type)
    
    if @image.save
      redirect_to :action => 'show', :id => @image.to_param
    else
      render :action => 'index'
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
