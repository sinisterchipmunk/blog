class CategoriesController < ApplicationController
  filter_resource_access :load_method => :load_category
  layout :choose_layout

  def load_category
    @category = (Category.find(params[:id]) rescue Category.find_by_permalink(params[:id]))
  end

  def choose_layout
    params[:action] == 'show' ? 'blog' : nil
  end
  private :choose_layout

  def show
    @posts = @category.posts
    @posts = @posts.select { |p| !p.publish_date.blank? } unless permitted_to?(:edit, :posts)
  end

  # POST /posts
  # POST /posts.xml
  def create
    respond_to do |format|
      if @category.save
        if params[:in_post]
          format.html
        else
          format.xml  { render :xml => @category, :status => :created, :location => @category }
        end
      else
        if params[:in_post]
          format.html { render :text => "<ul><li>#{@category.errors.full_messages.join("</li><li>")}</li></ul>", :status => :unprocessable_entry }
        else
          format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    respond_to do |format|
      if @category.update_attributes(params[:post])
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @category.destroy

    respond_to do |format|
      format.xml  { head :ok }
    end
  end
end
