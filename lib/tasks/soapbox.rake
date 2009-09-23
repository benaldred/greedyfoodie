namespace :soapbox do
  
  task :create_test_blog_post => :environment do
    id = 'testing123'
    @post = Post.get(id)
    
    #clear it out and start again
    @post.destroy if @post
    
    #grab the textile from the templates folder
    body = File.read(File.dirname(__FILE__) + "/soapbox/#{id}.textile")
    
    @post = Post.new(:title => id, :body => body)
    @post.save
  end

end