shared_examples_for "the sidebar has been setup" do
  it "should have setup the sidebar" do
    assigns[:recent_posts].should == [mock_post]
  end
end