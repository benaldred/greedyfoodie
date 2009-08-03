require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController do
  
  def mock_post(stubs={})
   @mock_post ||= mock(Post, stubs)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => 1
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show', :id => 1
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
    
    describe "with valid params" do
      
      it "exposes a newly created post as @post" do
        Post.should_receive(:new).with({'these' => 'params'}).and_return(mock_post(:save => true))
        post :create, :post => {:these => 'params'}
        assigns(:post).should equal(mock_post)
      end
      
      it "redirect to edit after creation" do
        Post.should_receive(:new).with({'these' => 'params'}).and_return(mock_post(:save => true, :status= => "published"))
        post :create, :post => {:these => 'params'}, :publish => 'Publish'
        response.should redirect_to(edit_admin_post_url(mock_post))
      end
      
      it "should set status to published when published" do
        Post.should_receive(:new).with({'these' => 'params'}).and_return(@foo = mock_post(:save => true))
        @foo.should_receive(:status=).with('published').and_return(true)
        post :create, :post => {:these => 'params'}, :publish => 'Publish'
      end
    
    end
    
    describe "with invalid params" do

      it "exposes a newly created but unsaved post as @post" do
        Post.stub!(:new).with({'these' => 'params'}).and_return(mock_post(:save => false))
        post :create, :post => {:these => 'params'}
        assigns(:post).should equal(mock_post)
      end

      it "re-renders the 'new' template" do
        Post.stub!(:new).and_return(mock_post(:save => false))
        post :create, :post => {}
        response.should render_template('new')
      end
      
    end
  end

  describe "PUT udpate" do

    describe "with valid params" do

      it "updates the requested post" do
        Post.should_receive(:get).with("37").and_return(mock_post)
        mock_post.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :post => {:these => 'params'}
      end

      it "exposes the requested post as @post" do
        Post.stub!(:get).and_return(mock_post(:update_attributes => true))
        put :update, :id => "1"
        assigns(:post).should equal(mock_post)
      end

      it "redirects to the post" do
        Post.stub!(:get).and_return(mock_post(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(edit_admin_post_url(mock_post))
      end

    end
    
    describe "with invalid params" do

      it "updates the requested post" do
        Post.should_receive(:get).with("37").and_return(mock_post)
        mock_post.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :post => {:these => 'params'}
      end

      it "exposes the post as @post" do
        Post.stub!(:get).and_return(mock_post(:update_attributes => false))
        put :update, :id => "1"
        assigns(:post).should equal(mock_post)
      end

      it "re-renders the 'edit' template" do
        Post.stub!(:get).and_return(mock_post(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "DELETE destroy" do

    it "destroys the requested post" do
      Post.should_receive(:get).with("37").and_return(mock_post)
      mock_post.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the posts list" do
      Post.stub!(:get).and_return(mock_post(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(admin_posts_url)
    end

  end
:post

end
