class PostsController < ApplicationController
  filter_resource_access :load_method => :load_post
  include PingbackHelper
  helper :pingback
  
  Pingback.save_callback do |pingback|
    ping = Ping.new
    ping.title       = pingback.title
    ping.url         = pingback.source_uri
    ping.content     = pingback.content

    referenced_article = Article.find_by_url(pingback.target_uri)

    if referenced_article
      referenced_article.pingbacks << ping
      referenced_article.save

      pingback.reply_ok # report success.
    else
      # report error:
      pingback.reply_target_uri_does_not_accept_posts
    end
  end

  def load_post
    options = { :include => { :comments => :author }}
    @post = (Post.find_by_permalink(params[:id], options) rescue Post.find(params[:id], options))
  end

  # GET /posts
  # GET /posts.xml
  def index
    conditions = {}
    unless permitted_to?(:edit, :posts)
      conditions = "NOT (publish_date IS NULL)"
    end
    @posts = filter_posts(Post.all(:order => "publish_date DESC, updated_at DESC", :conditions => conditions))
    # drafts have been moved to their own "Drafts" category.
    ## move drafts to top of list, or remove them if user isn't an author
    #@posts.insert(0, *@posts.select { |p| p.publish_date.nil? })
    @posts.uniq!

    respond_to do |format|
      format.html # index.html.erb
      format.yaml { render :text => @posts.to_yaml }
      format.xml  { render :xml => @posts }
      format.atom
      format.rss
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    set_xpingback_header
    @post.attributes = params[:post] if params[:post]
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
        handle_pingbacks
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
    check_for_draft
    respond_to do |format|
      if @post.update_attributes(params[:post])
        handle_pingbacks
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

  private
#  class XMLRPC::Client
#    alias _do_rpc do_rpc
#    
#    def do_rpc(request, async=false)
#      returning _do_rpc(request, async) do |t|
#        puts t.inspect
#      end
#    end
#  end
#  
#  
  def handle_pingbacks
    # check for pingbacks
    return unless @post.pingbacks_should_be_processed?
    parser = Hpricot(@post.body)
    link_tags = parser / :a
    link_tags.each do |link|
      href = link['href']
      response = Net::HTTP.get_response(URI.parse(href))
      pingback_url = response['X-Pingback']
      if pingback_url.nil?
        # try for a link tag
        parser = Hpricot(response.body)
        link_tags = parser / "link"
        pingback_tag = link_tags.select { |t| t['rel'].downcase.strip == 'pingback' }.shift
        pingback_url = pingback_tag['href'] if pingback_tag
      end
      
      if pingback_url
        server = XMLRPC::Client.new2(pingback_url)
        ok, param = server.call2("pingback.ping", post_url(@post), href)
  
        if ok then
          Rails.logger.info "Pingback response: #{param}"
        else
          Rails.logger.error "Pingback error: #{param.faultCode} (#{param.faultString})"
        end
      end
    end
  end
  
  def check_for_draft
    params[:post][:category_ids] ||= []
    if params[:post][:publish_date].blank?
      params[:post][:category_ids] << Category.find_by_name('Drafts').id
    else
      params[:post][:category_ids].delete Category.find_by_name('Drafts').id.to_s
    end
  end
end
