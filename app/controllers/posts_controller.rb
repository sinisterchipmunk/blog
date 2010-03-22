class PostsController < ApplicationController
  filter_resource_access :load_method => :load_post

  def load_post
    @post = (Post.find_by_permalink(params[:id]) rescue Post.find(params[:id]))
  end

  # GET /posts
  # GET /posts.xml
  def index
    conditions = {}
    unless permitted_to?(:edit, :posts)
      conditions = "NOT (publish_date IS NULL)"
    end
    @posts = Post.all(:order => "publish_date DESC, id DESC", :conditions => conditions)
    # move drafts to top of list, or remove them if user isn't an author
    @posts.insert(0, *@posts.select { |p| p.publish_date.nil? })
    @posts.uniq!

    respond_to do |format|
      format.html # index.html.erb
      format.yaml { render :text => @posts.to_yaml }
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.yaml { render :text => @post.to_yaml }
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post.author = current_user
    @post.current_revision.user = current_user
    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post.author ||= current_user
    @post.current_revision.user = current_user
    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
