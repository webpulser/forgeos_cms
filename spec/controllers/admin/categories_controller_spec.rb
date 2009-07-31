require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::CategoriesController, "GET index" do
  should_require_login :get, :index

  describe "admin client" do
  
    before(:each) do
      login_as_admin
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:all).and_return @categories
    end
    
    should_load_company :get, :index

    it "should load all categories" do
      @company.should_receive(:categories)
      @company_categories.should_receive(:all)
      get :index
    end
    
    it "should assign @categories" do
      get :index
      assigns[:categories].should == @categories
    end
    
    it "should render the index template" do
      get :index
      response.should render_template("index")
    end
  end
end

describe Admin::CategoriesController, "GET show" do
  should_require_login :get, :show

  describe "admin client" do

    before :each do
      login_as_admin
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:find_by_id).and_return @category
    end

    should_load_company :get, :show

    it "should load the required category" do
      @company.should_receive(:categories)
      @company_categories.should_receive(:find_by_id).with("1")
      get :show, :id => 1
    end
  
    it "should assign @category" do
      get :show
      assigns[:category].should == @category
    end
    
    it "should render the show template" do
      get :show
      response.should render_template("show")
    end

    context "when category does not exist" do
      before(:each) do
        @company_categories.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        get :show
        flash[:error].should == "Category does not exist"
      end
    end
  end
end

describe Admin::CategoriesController, "GET new" do
  should_require_login :get, :new

  describe "admin client" do
  
    before(:each) do
      login_as_admin
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:new).and_return @category
    end

    should_load_company :get, :new

    it "should load the required category" do
      @company.should_receive(:categories)
      @company_categories.should_receive(:new)
      get :new
    end
    
    it "should assign @category" do
      get :new
      assigns[:category].should == @category
    end
    
    it "should assign @categories" do
      get :new
      assigns[:categories].should == @categories
    end
    
    it "should render the new template" do
      get :new
      response.should render_template("new")
    end
  end
end

describe Admin::CategoriesController, "GET edit" do
  should_require_login :get, :edit

  describe "admin client" do
  
    before(:each) do
      login_as_admin
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:find_by_id).and_return @category
    end

    should_load_company :get, :edit

    it "should load the required category" do
      @company.should_receive(:categories)
      @company_categories.should_receive(:find_by_id).with("1")
      get :edit, :id => 1
    end
    
    it "should assign @category" do
      get :edit
      assigns[:category].should == @category
    end
    
    it "should assign @categories" do
      get :edit
      assigns[:categories].should == @categories
    end
    
    it "should render the edit template" do
      get :edit
      response.should render_template("edit")
    end

    context "when category does not exist" do
      before(:each) do
        @company_categories.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        get :edit
        flash[:error].should == "Category does not exist"
      end
    end
  end
end

describe Admin::CategoriesController, "POST create" do
  should_require_login :post, :create
  
  describe "admin client" do
  
    before(:each) do
      login_as_admin
      @category = mock_model(Category, :save => nil)
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:new).and_return @category
    end

    should_load_company :post, :create

    it "should build a new category" do
      @company.should_receive(:categories)
      @company_categories.should_receive(:new).with('url' => "www.webpulser.com", 'client_id' => "1").and_return(@category)
      post :create, :category => {'url' => "www.webpulser.com", 'client_id' => "1"}
    end
  
    it "should save the category" do
      @category.should_receive(:save)
      post :create
    end
    
    context "when the category saves successfully" do
      before(:each) do
        @category.stub!(:save).and_return true
      end
      
      it "should set a flash[:notice] message" do
        post :create
        flash[:notice].should == "The category was successfully created"
      end
      
      it "should redirect to the categories index" do
        post :create
        response.should redirect_to(admin_client_categories_path(@company))
      end
    end
    
    context "when the category fails to save" do
      before(:each) do
        @category.stub!(:save).and_return false
      end

      it "should assign @category" do
        post :create
        assigns[:category].should == @category
      end
      
      it "should put a message in flash[:error]" do
        post :create
        flash[:error].should == "A problem occurred during the category creation"
      end
      
      it "should render the new template" do
        post :create
        response.should render_template("new")
      end
    end
  end
end

describe Admin::CategoriesController, "PUT update" do
  should_require_login :put, :update
  
  describe "admin client" do
    before(:each) do
      login_as_admin
      @category = mock_model(Category, :save => nil)
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:find_by_id).and_return @category
    end

    should_load_company :put, :update
    
    context "when the category saves successfully" do
      before(:each) do
        @category.stub!(:update_attributes).and_return true
      end

      it "should load the required category" do
        @company.should_receive(:categories)
        @company_categories.should_receive(:find_by_id).with("1").and_return @category
        put :update, :id => 1
      end

      it "should save the category" do
        @category.should_receive(:update_attributes).with('url' => 'www.forgeos.com', 'client_id' => '1').and_return(true)
        put :update, :category => { :url => 'www.forgeos.com', :client_id => '1' }
      end
      
      it "should set a flash[:notice] message" do
        put :update
        flash[:notice].should == "The category was successfully updated"
      end
      
      it "should redirect to the categories index" do
        put :update
        response.should redirect_to(admin_client_categories_path(@company))
      end
    end

    context "when the category does not exist" do
      before(:each) do
        @company_categories.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        put :update
        flash[:error].should == "Category does not exist"
      end

      it "should redirect to the categories index" do
        put :update
        response.should redirect_to(admin_client_categories_path(@company))
      end
    end
    
    context "when the category fails to save" do
      before(:each) do
        @category.stub!(:update_attributes).and_return false
        Client.stub!(:all).and_return @clients
      end
      
      it "should assign @category" do
        put :update
        assigns[:category].should == @category
      end
      
      it "should assign @clients" do
        put :update
        assigns[:clients].should == @clients
      end

      it "should put a message in flash[:error]" do
        put :update
        flash[:error].should == "A problem occurred during the category update"
      end
      
      it "should render the edit template" do
        put :update
        response.should render_template("edit")
      end
    end
  end
end

describe Admin::CategoriesController, "DELETE destroy" do
  should_require_login :delete, :destroy

  describe "admin client" do
  
    before(:each) do
      login_as_admin
      @category = mock_model(Category, :save => nil)
      @company = mock_model(Client, :null_object => true)
      Client.stub!(:find_by_id).and_return(@company)
      @company_categories = mock_model(Category)
      @company.stub!(:categories).and_return(@company_categories)
      @company_categories.stub!(:find_by_id).and_return @category
    end

    should_load_company :delete, :destroy
    
    context "when the category is successfully deleted" do
      before(:each) do
        @category.stub!(:destroy).and_return true
      end

      it "should load the required category" do
        @company.should_receive(:categories)
        @company_categories.should_receive(:find_by_id).with("1")
        delete :destroy, :id => 1
      end

      it "should delete the category" do
        @category.should_receive(:destroy)
        delete :destroy
      end
      
      it "should set a flash[:notice] message" do
        delete :destroy
        flash[:notice].should == "The category was successfully deleted"
      end
      
      it "should redirect to the categories index" do
        delete :destroy
        response.should redirect_to(admin_client_categories_path(@company))
      end
    end

    context "when category does not exist" do
      before(:each) do
        @company_categories.stub!(:find_by_id).and_return nil
      end

      it "should put a message in flash[:error]" do
        delete :destroy
        flash[:error].should == "Category does not exist"
      end

      it "should redirect to the categories index" do
        delete :destroy
        response.should redirect_to(admin_client_categories_path(@company))
      end
    end
    
    context "when the category fails to delete" do
      before(:each) do
        @category.stub!(:destroy).and_return false
      end
      
      it "should assign @category" do
        delete :destroy
        assigns[:category].should == @category
      end

      it "should put a message in flash[:error]" do
        delete :destroy
        flash[:error].should == "A problem occurred during the category destruction"
      end
      
      it "should render the show template" do
        delete :destroy
        response.should redirect_to(admin_client_categories_path(@company))
      end
    end
  end
end
