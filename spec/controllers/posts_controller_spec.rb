require 'spec_helper'
require "xmlrpc/server"

# Cucumber covers most scenarios. This spec is to cover sending pingbacks; parsing and retrieving images; and receiving
# pingbacks.

def _post(body = "a body", options = {})
  {
    :id => options[:id],
    :single_access_token => User.first.single_access_token,
    :post => { :title => "A Title", :publish_date => options[:publish_date],
      :current_revision_attributes => {
        :body => body
      }
    }
  }
end

describe PostsController do
  before(:each) do
    # log in
    #User.destroy_all # why do I have to do this?
    u = User.new(:email => "generic@example.com", :display_name => "Generic", :username => "generic")
    u.password = u.password_confirmation = "Generic12"
    u.save!
    u.roles << Role.create(:name => "admin")

    blog = Blog.new :name => "My Blog"
    blog.owner = u
    blog.save!
  end
  
  context "with a post that has a pingback" do
    before(:each) do
      post = Post.new(:title => "a title", :author => User.first)
      post.save!
      
      Pingback.new("http://test.host/posts/a-title", "http://test.host/posts/a-title", request).receive_ping
    end
    
    it "should allow pingback to be deleted" do
      email = mailbox_for(Blog.first.owner.email).last
      links = (Hpricot(email.body) / :a)
      link = links[-1]
      
      path = link['href'].gsub(/^.*?#{Regexp::escape request.host}/, '')
      path = "/#{path}" unless path[0] == ?/
      params = {}
      if path['?']
        query = path[(path.index('?')+1)..-1]
        path = path[0...path.index('?')]
        params = ActionController::Routing::Routes.recognize_path(path)

        values = query.split(/\&/)
        params.merge!(values.inject({}) do |hash, v|
          k, v = v.split(/=/)
          hash[k] = v
          hash
        end)
      end
      
      # What's the deal with named routes? Routing doesn't recognize them properly?
      params[:id], params[:action] = params[:action], params[:id]
      params = params.with_indifferent_access
      
      get params.delete(:action), params
      
      flash[:error].should be_nil # just so I can see the error message...
      Ping.count.should == 0
    end
  end
  
  context "new" do
    context "draft" do
      it "should not process pingbacks" do
        Net::HTTP.should_not_receive(:get_response)
        post :create, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>")
      end
    end

    context "published" do
      it "should process pingbacks" do
        post :create, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => Time.now)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
      end
    end
    
    context "published then updated" do
      it "should process pingbacks only once" do
        post :create, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => Time.now)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
        
        post :update, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => Time.now, :id => Post.first.id)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
        
        Post.count.should == 1
      end
    end
    
    context "published, then updated with additional links" do
      before(:each) do
        post :create, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => Time.now)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
      end
      
      it "should not process the same link twice" do
        post :update, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a> " +
                            "and here's one to <a href='http://www.thoughtsincomputation.com/posts/2' />something else</a>",
                            :publish_date => Time.now, :id => Post.first.id)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1',
                                               'http://www.thoughtsincomputation.com/posts/2']
      end
    end
    
    context "published, unpublished, published again" do
      it "should process pingbacks only once" do
        post :create, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => Time.now)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
        Post.first.should_not be_draft
        
        post :update, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => nil, :id => Post.first.id)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
        Post.first.should be_draft

        post :update, _post("here'a a link to <a href='http://www.thoughtsincomputation.com/posts/1' />something neat</a>", :publish_date => Time.now, :id => Post.first.id)
        Post.first.pingback_history.should == ['http://www.thoughtsincomputation.com/posts/1']
        
        Post.count.should == 1
      end
    end
  end
  
  context "receiving a pingback" do
    it "should register the pingback" do
      post = Post.new(:title => "a title", :author => User.first)
      post.save!
      
      xmlrpc = XMLRPC::BasicServer.new
  
      xmlrpc.add_handler("pingback.ping") do |source_uri, target_uri|
        begin
          Pingback.new(source_uri, target_uri, request).receive_ping
        rescue
          $xml_err = $!
          raise $!
        end
      end
  
      xml_response = xmlrpc.process(File.read(File.join(File.dirname(__FILE__), "../support/xml/pingback_request.xml")))
  
      # Log the error if there is one
      parser = XMLRPC::XMLParser::XMLStreamParser.new
      ret = parser.parseMethodResponse(xml_response)
      raise $xml_err if $xml_err
      raise "XMLRPC fault raised. Code: #{ret[1].faultCode}: Message: #{ret[1].faultString}" unless ret[0]
  
      Post.first.pingbacks.should_not be_empty
      
      # We also want it to send an email notification to the blog owner.
      mailbox_for(Blog.first.owner.email).size.should == 1
    end
  end
end