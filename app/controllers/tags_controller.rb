class TagsController < ApplicationController
  filter_resource_access :load_method => :load_tag
  layout :choose_layout

  def load_tag
    @tag = (Tag.find(params[:id]) rescue Tag.find_by_permalink(params[:id]))
  end

  def choose_layout
    params[:action] == 'show' ? 'blog' : nil
  end
  private :choose_layout

  def show
    @posts = filter_posts @tag.posts
  end

  # POST /posts
  # POST /posts.xml
  def create
    
    respond_to do |format|
      if @tag.save
        if params[:in_post]
          format.html
        else
          format.xml  { render :xml => @tag, :status => :created, :location => @tag }
        end
      else
        if params[:in_post]
          format.html { render :text => "<ul><li>#{@tag.errors.full_messages.join("</li><li>")}</li></ul>", :status => :unprocessable_entry }
        else
          format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    respond_to do |format|
      if @tag.update_attributes(params[:post])
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @tag.destroy

    respond_to do |format|
      format.xml  { head :ok }
    end
  end
end
