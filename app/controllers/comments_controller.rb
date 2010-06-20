class CommentsController < ApplicationController
  filter_resource_access
  layout 'blog'
  before_filter :find_post

  # GET /comments
  # GET /comments.xml
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.xml
  def create
    respond_to do |format|
      @comment.author = current_user
      @comment.post = @post
      if @comment.save
        flash[:notice] = 'Comment was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    respond_to do |format|
      if @comment.author != current_user || @comment.post != @post
        message = "Something about this comment's meta data doesn't add up, so I've prevented you from editing it. I'm looking into this. Sorry!"
        flash[:error] = message
        format.html { redirect_to(@post) }
        format.xml { render :xml => message, :status => :unprocessable_entity }
      elsif @comment.update_attributes(params[:comment])
        flash[:notice] = 'Comment was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to(@post) }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_post
    @post = Post.find_by_permalink(params[:post_id])
  end
end
