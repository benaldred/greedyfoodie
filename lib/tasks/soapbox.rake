require 'faker'
namespace :soapbox do
  
  task :create_test_posts => :environment do


    
    #grab the textile from the templates folder
    body = File.read(File.dirname(__FILE__) + "/soapbox/test_post.textile")
    now = Time.now

    5.times do |i|
      title = Faker::Lorem.sentence
      @post = Post.new(:title => title, :body => body, :created_at => Time.gm(now.year, now.month, i+1, now.hour, now.min, now.sec), :status => 'published')
      @post.save!
    end
  end

end