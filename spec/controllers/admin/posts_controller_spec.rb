require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::PostsController do
  
  def mock_post(stubs={})
    @mock_post ||= mock(Post, stubs.merge!({:permalink => 'foo'}))
  end
  
  before do
    login
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
        response.should redirect_to(edit_admin_post_url(mock_post.permalink))
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
    
    describe "rendering preview" do
      
      it "should write post to session as 'post_preview'" do
        Post.should_receive(:new).with({'these' => 'params'}).and_return(mock_post(:generate_unique_permalink_from_title => 'foo'))
        post :create, :post => {:these => 'params'}, :preview => 'Preview'
        session["post_preview"].should == mock_post
      end
        
      it "should redirect to preview page" do
        Post.should_receive(:new).with({'these' => 'params'}).and_return(mock_post(:generate_unique_permalink_from_title => 'foo'))
        post :create, :post => {:these => 'params'}, :preview => 'Preview'
        response.should redirect_to(preview_admin_post_url(mock_post.permalink))
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
        response.should redirect_to(edit_admin_post_url(mock_post.permalink))
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
    
    describe "rendering preview" do
      before do
        Post.stub!(:get).and_return(mock_post(:generate_unique_permalink_from_title => 'foo'))
        Post.should_receive(:new).with({'these' => 'params'}).and_return(mock_post(:generate_unique_permalink_from_title => 'foo'))
      end
      
      it "should create fresh post and expose as @new_post" do
        post :update, :id => "foo", :post => {:these => 'params'}, :preview => 'Preview'
        assigns(:new_post).should equal(mock_post)
      end
      
      it "should write post to session as 'post_preview'" do
        post :update, :id => "foo", :post => {:these => 'params'}, :preview => 'Preview'
        session["post_preview"].should == mock_post
      end
        
      it "should redirect to preview page" do
        post :update, :id => "foo", :post => {:these => 'params'}, :preview => 'Preview'
        response.should redirect_to(preview_admin_post_url(mock_post.permalink))
      end
    end

  end
  
  describe "GET /preview" do    
    it "exposes a post initialised from the cache as @post" do
      session[:post_preview] = mock_post
      get :preview
      assigns(:post).should equal(mock_post)
    end
  
    it "should clear the session" do
      session[:post_preview] = mock_post
      get :preview
      session["post_preview"].should == nil
    end
  
    it "should render the 'posts/show' template" do
      session[:post_preview] = mock_post
      get :preview
      response.should render_template('posts/show')
    end   
  end     
  
  describe "GET /id/preview" do
    it "use the id to init the post" do
      Post.stub!(:get).and_return(mock_post)
      get :preview, :id => 'foo'
      assigns(:post).should equal(mock_post)
    end
  
    it "should render the 'posts/show' template" do
      Post.stub!(:get).and_return(mock_post)
      get :preview, :id => 'foo'
      response.should render_template('posts/show')
    end    
  end
  
  describe "POST post_preview" do
    
    it "exposes a newly created post as @post" do
      Post.should_receive(:new).with({:title => 'foo', :body => 'bar'}).and_return(mock_post)
      post :post_preview, :post_title => 'foo', :post_body => 'bar'
      assigns(:post).should equal(mock_post)
    end
    
    it "should render the 'posts/show' template" do
      Post.stub!(:new).and_return(mock_post)
      post :post_preview, :post => {}
      response.should render_template('posts/show')
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

end
