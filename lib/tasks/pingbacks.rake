namespace :pingbacks do
  desc "test pingbacks"
  task :test do
    require "xmlrpc/client"

    server = XMLRPC::Client.new2("http://localhost:3000/pingback/xml")
    linker_url = "http://www.thoughtsincomputation.com/posts/another-post"
    post_url = "http://localhost:3000/posts/post-title"
  
    ok, param = server.call2("pingback.ping", linker_url, post_url)
  
    if ok then
      puts "Response: #{param}"
    else
      puts "Error:"
      puts param.faultCode 
      puts param.faultString
    end
  end
end

task :pingbacks => "pingbacks:test"
