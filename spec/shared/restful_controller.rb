module RestfulControllerExampleHelperMethods
  
  def setup_restful_controller
    
    # sensible default take the controller name and assume the model matches i.e. AssetsController => asset
    # get controller_name from ActionController::TestRequest 
    @model = self.controller.controller_class_name.gsub("Controller", "").downcase.singularize unless instance_variable_get(:@model)
    
    # set up the variables we'll use in specs below
    @model = @model.to_s.downcase.to_sym                        # => :asset or :eggs_and_ham
    @pluralized_model = @model.to_s.pluralize.to_sym            # => :assets or :eggs_and_hams
    @model_name = @model.to_s.classify                          # => "Asset" or "EggsAndHam"
    @model_klass  = @model_name.constantize                     # => Asset or EggsAndHam
    @pluralized_model_name = @model_name.humanize.pluralize     # => 'Assets' or "Eggsandhams"
  
  
    # Add a dynamic helper method for creating mocks
    #def mock_asset(stubs={})
    #  @mock_asset ||= mock_model(Asset, stubs)
    #end
    eval("def mock_#{@model}(stubs={}); @mock_#{@model} ||= mock_model(@model_klass, stubs); end")
    
    # store useful helper method names to use when using send
    @mock_model_name  = "mock_#{@model}"            # => "mock_asset"
    @model_url        = "#{@model}_url"             # => "asset_url"
    @models_url       = "#{@pluralized_model}_url"  # => "assets_url"
  end
end

module RestfulController
  
  
  #--------------------------------------
  #
  #   Restful controller routing specs
  #
  #   it_should_behave_like "a restfully routed controller"
  #
  #--------------------------------------
  
  shared_examples_for "a restfully routed controller" do
    
    
    # use the described_class from Spec::Example::ExampleGroupMethods in rspec
    # turn ArticlesController => articles
    restful_controller_name = self.described_class.to_s.gsub("Controller", "").downcase
  
    describe "route generation" do

      it "maps #index" do
        route_for(:controller => restful_controller_name, :action => "index").should == "/#{restful_controller_name}"
      end
  
      it "maps #new" do
        route_for(:controller => restful_controller_name, :action => "new").should == "/#{restful_controller_name}/new"
      end
  
      it "maps #show" do
        route_for(:controller => restful_controller_name, :action => "show", :id => "1").should == "/#{restful_controller_name}/1"
      end
  
      it "maps #edit" do
        route_for(:controller => restful_controller_name, :action => "edit", :id => "1").should == "/#{restful_controller_name}/1/edit"
      end

      it "maps #create" do
        route_for(:controller => restful_controller_name, :action => "create").should == {:path => "/#{restful_controller_name}", :method => :post}
      end

      it "maps #update" do
        route_for(:controller => restful_controller_name, :action => "update", :id => "1").should == {:path =>"/#{restful_controller_name}/1", :method => :put}
      end
  
      it "maps #destroy" do
        route_for(:controller => restful_controller_name, :action => "destroy", :id => "1").should == {:path =>"/#{restful_controller_name}/1", :method => :delete}
      end
    end
    
    describe "route recognition" do
      it "generates params for #index" do
        params_from(:get, "/#{restful_controller_name}").should == {:controller => restful_controller_name, :action => "index"}
      end

      it "generates params for #new" do
        params_from(:get, "/#{restful_controller_name}/new").should == {:controller => restful_controller_name, :action => "new"}
      end

      it "generates params for #create" do
        params_from(:post, "/#{restful_controller_name}").should == {:controller => restful_controller_name, :action => "create"}
      end

      it "generates params for #show" do
        params_from(:get, "/#{restful_controller_name}/1").should == {:controller => restful_controller_name, :action => "show", :id => "1"}
      end

      it "generates params for #edit" do
        params_from(:get, "/#{restful_controller_name}/1/edit").should == {:controller => restful_controller_name, :action => "edit", :id => "1"}
      end

      it "generates params for #update" do
        params_from(:put, "/#{restful_controller_name}/1").should == {:controller => restful_controller_name, :action => "update", :id => "1"}
      end

      it "generates params for #destroy" do
        params_from(:delete, "/#{restful_controller_name}/1").should == {:controller => restful_controller_name, :action => "destroy", :id => "1"}
      end
    end
  end
  
  #--------------------------------------
  #
  #   Restful controller specs
  #
  #--------------------------------------
  
  # TODO - would be nice to have dynamically generated helper methods like
  # also dynamically generated 'it' blocks like
  # it "exposes all #{@test} as @#{@pluralized_model}" do
  
  # TODO - only include in controller specs
  
  shared_examples_for "a standard restful controller" do
    it_should_behave_like "restful GET index"
    it_should_behave_like "restful GET show"
    it_should_behave_like "restful GET new"
    it_should_behave_like "restful GET edit"
    it_should_behave_like "restful POST create"
    it_should_behave_like "restful PUT update"
    it_should_behave_like "restful DELETE destroy"
  end
  
  shared_examples_for "restful GET index" do
    include RestfulControllerExampleHelperMethods

    before do
      setup_restful_controller
    end

    describe "restful GET index" do
      
      it "assigns collection for the view" do
        @model_klass.stub!(:all).and_return([send(@mock_model_name)])
        get :index
        assigns[@pluralized_model].should == [send(@mock_model_name)]
      end
      
      describe "with mime type of xml" do

        it "renders all as xml" do
          @model_klass.should_receive(:find).with(:all).and_return(@pluralized_model = mock("Array of #{@pluralized_model_name}"))
          @pluralized_model.should_receive(:to_xml).and_return("generated XML")
          get :index, :format => 'xml'
          response.body.should == "generated XML"
        end
      end
    end

  end
  
  shared_examples_for "restful GET show" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
  
    describe "restful GET show" do

      it "assign resource for the view" do
        @model_klass.should_receive(:find).with("37").and_return(send(@mock_model_name))
        get :show, :id => "37"
        assigns[@model].should equal(send(@mock_model_name))
      end

      describe "with mime type of xml" do

        it "renders the requested object as xml" do
          @model_klass.should_receive(:find).with("37").and_return(send(@mock_model_name))
          send(@mock_model_name).should_receive(:to_xml).and_return("generated XML")
          get :show, :id => "37", :format => 'xml'
          response.body.should == "generated XML"
        end
      end
    end
  
  end  
  
  shared_examples_for "restful GET new" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    describe "restful GET new" do
    
      it "assigns new object for the view" do
        @model_klass.should_receive(:new).and_return(send(@mock_model_name))
        get :new
        assigns[@model].should equal(send(@mock_model_name))
      end
    
      describe "with mime type of xml" do

        it "renders the requested object as xml" do
          @model_klass.should_receive(:new).and_return(send(@mock_model_name))
          send(@mock_model_name).should_receive(:to_xml).and_return("generated XML")
          get :new, :format => 'xml'
          response.body.should == "generated XML"
        end
      end
    end
    
  end
  
  shared_examples_for "restful GET edit" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    describe "restful GET edit" do
    
      it "assign resource for the view" do
        @model_klass.should_receive(:find).with("37").and_return(send(@mock_model_name))
        get :edit, :id => "37"
        assigns[@model].should equal(send(@mock_model_name))
      end
    end
    
  end
  
  # generic restful POST create specs
  shared_examples_for "POST create" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    describe "restful POST create" do

      describe "with valid params" do

        it "exposes a newly created object to the view" do
          @model_klass.should_receive(:new).with({'these' => 'params'}).and_return(send(@mock_model_name, :save => true))
          post :create, @model => {:these => 'params'}
          assigns(@model).should equal(send(@mock_model_name))
        end

      end

      describe "with invalid params" do

        it "exposes a newly created but unsaved object to the view" do
          @model_klass.stub!(:new).with({'these' => 'params'}).and_return(send(@mock_model_name, :save => false))
          post :create, @model => {:these => 'params'}
          assigns(@model).should equal(send(@mock_model_name))
        end

        it "re-renders the 'new' template" do
         @model_klass.stub!(:new).and_return(send(@mock_model_name, :save => false))
         post :create, @model => {}
         response.should render_template('new')
        end
      end
    end
    
  end
  
  
  # standard POST create
  shared_examples_for "restful POST create" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    it_should_behave_like "POST create"
    
    describe "with valid params" do

      it "redirects to show the created object" do
        @model_klass.stub!(:new).and_return(send(@mock_model_name, :save => true))
        post :create, @model => {}
        # redirect meta progarmming
        # => response.should redirect_to(asset_url(mock_asset))
        response.should redirect_to( send(@model_url, send(@mock_model_name) ) )
      end

    end
    
    
  end
  
  # POST create that redirects to index
  shared_examples_for "restful POST create redirecting to index" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    it_should_behave_like "POST create"
    
    describe "with valid params" do

      it "redirects to show the created object" do
        @model_klass.stub!(:new).and_return(send(@mock_model_name, :save => true))
        post :create, @model => {}
        response.should redirect_to(send(@models_url))
      end

    end
  end
  
  
  # generic restful PUT update specs
  shared_examples_for "PUT update" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    describe "restful PUT udpate" do

      describe "with valid params" do

        it "updates the requested object" do
          @model_klass.should_receive(:find).with("37").and_return(send(@mock_model_name))
          send(@mock_model_name).should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", @model => {:these => 'params'}
        end

        it "exposes the requested object to the view" do
          @model_klass.stub!(:find).and_return(send(@mock_model_name, :update_attributes => true))
          put :update, :id => "1"
          assigns(@model).should equal(send(@mock_model_name))
        end

      end

      describe "with invalid params" do

        it "updates the requested object" do
          @model_klass.should_receive(:find).with("37").and_return(send(@mock_model_name))
          send(@mock_model_name).should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", @model => {:these => 'params'}
        end

        it "exposes the object as @object" do
          @model_klass.stub!(:find).and_return(send(@mock_model_name, :update_attributes => false))
          put :update, :id => "1"
          assigns(@model).should equal(send(@mock_model_name))
        end

        it "re-renders the 'edit' template" do
          @model_klass.stub!(:find).and_return(send(@mock_model_name, :update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end

      end

    end
    
  end
  
  shared_examples_for "restful PUT update" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    it_should_behave_like "PUT update"
    
    describe "with valid params" do
      it "redirects to the show the object" do
        @model_klass.stub!(:find).and_return(send(@mock_model_name, :update_attributes => true))
        put :update, :id => "1"
        # redirect meta progarmming
        # => response.should redirect_to(asset_url(mock_asset))
        response.should redirect_to( send(@model_url, send(@mock_model_name) ) )
      end
    end
  end
  
  shared_examples_for "restful PUT update redirecting to index" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    it_should_behave_like "PUT update"
    
    describe "with valid params" do
      it "redirects to the show the object" do
        @model_klass.stub!(:find).and_return(send(@mock_model_name, :update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(send(@models_url))
      end
    end
  end
  
  shared_examples_for "restful DELETE destroy" do
    include RestfulControllerExampleHelperMethods
    
    before do
      setup_restful_controller
    end
    
    describe "restful DELETE destroy" do

      it "destroys the requested object" do
        @model_klass.should_receive(:find).with("37").and_return(send(@mock_model_name))
        send(@mock_model_name).should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the object list page" do
        @model_klass.stub!(:find).and_return(send(@mock_model_name, :destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(send(@models_url))
      end
    end
  end
  
  
end