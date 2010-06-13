class CategoriesController < ApplicationController
  filter_resource_access :load_method => :load_category
  layout :choose_layout

  def load_category
    @category = (Category.find(params[:id]) rescue Category.find_by_permalink(params[:id]))
  end

  def choose_layout
    %w(show index).include?(params[:action]) ? 'blog' : nil
  end
  private :choose_layout

  def index
    @category = Category.new(:name => 'All Posts')
    @posts = filter_posts Post.all(:order => 'publish_date DESC, updated_at DESC')
    @new_post_for_category = Post.new

    respond_to do |fmt|
      fmt.html { render :action => :show }
      fmt.yaml { render :text   => @posts.to_yaml }
      fmt.xml  { render :xml    => @posts }
    end
  end

  def show
    @posts = filter_posts @category.posts.find(:all, :order => 'publish_date DESC, updated_at DESC')
    @new_post_for_category = Post.new
    @new_post_for_category.post_categories.build(:category => @category)

    respond_to do |fmt|
      fmt.html
      fmt.yaml { render :text => @posts.to_yaml }
      fmt.xml  { render :xml  => @posts }
    end
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
