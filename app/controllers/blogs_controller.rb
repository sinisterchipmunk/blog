class BlogsController < ApplicationController
  filter_resource_access :load_method => :load_blog, :new => [ :new, :create, :author ]

  def load_blog
    @blog = (Blog.find(params[:id]))
  end
  
  def author
    @blog = Blog.first
    @author = @blog.owner
  end

  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html { redirect_to root_url }
        format.xml  { head :ok }
      else
        @blog.errors.full_messages.each { |message| logger.error message }
        flash[:error] = "Could not save blog: #{@blog.errors.full_messages.join("; ")}"
        format.html { redirect_to root_url }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end
end
