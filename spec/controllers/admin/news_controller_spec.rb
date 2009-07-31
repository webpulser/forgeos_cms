require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::NewsController, 'GET index' do
  initialize_currency
  should_require_admin_login :get, :index

  describe 'admin news' do

    before :each do
      login_as_admin
      New.stub!(:all).and_return @news
    end

    it 'should load all news' do
      New.should_receive(:all)
      get :index
    end

    it 'should assign @news' do
      get :index
      assigns[:news].should == @news
    end

    it 'should render the index template' do
      get :index
      response.should render_template('index')
    end
  end
end

describe Admin::NewsController, 'GET show' do
  initialize_currency
  should_require_admin_login :get, :show

  describe 'admin news' do

    before :each do
        login_as_admin
        New.stub!(:find_by_id).and_return @new
    end
    
    context 'when news exists' do
      it 'should load the news' do
        New.should_receive(:find_by_id).with('1')
        get :show, :id => 1
      end

      it 'should assign @new' do
        get :show
        assigns[:new].should == @new
      end

      it 'should render the show template' do
        get :show
        response.should render_template('show')
      end
    end
    context 'when news does not exist' do
      before :each do
        @news.stub!(:find_by_id).and_return nil
      end

      it 'should set a flash[:error] message' do
        get :show
        flash[:error].should_not == nil
      end

      it 'should redirect to admin news index' do
        get :show
        response.should redirect_to(admin_news_index_path)
      end
    end
  end
end

describe Admin::NewsController, 'GET new' do
  initialize_currency
  should_require_admin_login :get, :new

  describe 'admin news' do
    before :each do
      login_as_admin
      New.stub!(:new).and_return @new
    end

    it 'should create a new news' do
      New.should_receive(:new)
      get :new
    end

    it 'should assign @new' do
      get :new
      assigns[:new].should == @new
    end

    it 'should render the new template' do
      get :new
      response.should render_template('new')
    end
  end
end

describe Admin::NewsController, 'GET edit' do
  initialize_currency
  should_require_admin_login :get, :edit

  describe 'admin news' do
    before :each do
      login_as_admin
      New.stub!(:find_by_id).and_return @new
    end

    context 'when news exists' do
      it 'should find the required new' do
        New.should_receive(:find_by_id).with('1')
        get :edit, :id => 1
      end

      it 'should assign @new' do
        get :edit
        assigns[:new].should == @new
      end

      it 'shoud render the edit template' do
        get :edit
        response.should render_template('edit')
      end
    end

    context 'when news does not exists' do
      it 'should set a flash[:error] message' do
        get :edit
        flash[:error].should_not == nil
      end

      it 'should redirect to admin news index' do
        get :edit
        response.should redirect_to(admin_news_index_path)
      end
    end
  end
end

describe Admin::NewsController, 'POST create' do
  initialize_currency
  should_require_admin_login :post, :create

  describe 'admin news' do

    before :each do
      login_as_admin
      @new = mock_model(New, :null_object => true)
      New.stub!(:new).and_return @new
    end

    it 'should build a new news' do
      New.should_receive(:new).with('title' => "Let's go!", 'content' => 'Here we go!').and_return @new
      post :create, :new => {'title' => "Let's go!", 'content' => 'Here we go!'}
    end

    it 'should save the news' do
      @new.should_receive(:save)
      post :create
    end

    context 'when the news saves successfully' do
      before :each do
        @new.stub!(:save).and_return true
      end

      it 'should set a flash[:notice] message' do
        post :create
        flash[:notice].should_not == nil
      end

      it 'should redirect to the news created' do
        post :create
        response.should redirect_to(admin_news_path(@new))
      end
    end

    context 'when the news fails to save' do
      before :each do
        @new.stub!(:save).and_return false
      end
      
      it 'should set a flash[:error] message' do
        post :create
        flash[:error].should_not == nil
      end

      it 'should render the new template' do
        post :create
        response.should render_template('new')
      end
    end
  end
end

describe Admin::NewsController, 'PUT update' do
  initialize_currency
  should_require_admin_login :put, :update

  describe 'admin news' do

    before :each do
      login_as_admin
      @new = mock_model(New, :save => nil, :null_object => true)
      New.stub!(:find_by_id).and_return @new
    end

    context 'when the news updates successfully' do
      before :each do
        @new.stub!(:update_attributes).and_return true
      end
      
      it 'should find the required new' do
        New.should_receive(:find_by_id).with('1').and_return @new
        put :update, :id => 1
      end

      it 'should update the news' do
        @new.should_receive(:update_attributes).with('title' => 'Nice try', 'content' => 'Or not')
        put :update, :new => { :title => 'Nice try', 'content' => 'Or not'}
      end

      it 'should set a flash[:notice] message' do
        put :update
        flash[:notice].should_not == nil
      end

      it 'should redirect to the news edit path' do
        put :update
        response.should redirect_to(admin_news_path(@new))
      end
    end

    context 'when the news fails to update' do
      before :each do
        @new.stub!(:update_attributes).and_return false
      end

      it 'should assign @new' do
        put :update
        assigns[:new].should == @new
      end

      it 'should set a flash[:error] message' do
        put :update
        flash[:error].should_not == nil
      end

      it 'should render the edit action' do
        put :update
        response.should render_template('edit')
      end
    end
  end
end


#describe Admin:NewsController, 'DELETE destroy' do
#  initialize_currency
#  should_require_admin_login :delete, :destroy
#
#  describe 'admin news' do
#    before :each do
#      login_as_admin
#      @new = mock_model(New, :save => nil, :null_object => true)
#      New.stub!(:find_by_id).and_return @new
#    end
#
#    context 'when the news exists' do
#
#    end
#  end
#end
#describe Admin::NewsController, 'DELETE destroy' do
#  initialize_currency
#  should_require_admin_login :delete, :destroy
#
#  describe 'admin news' do
#    before :each do
#      login_as_admin
#      @new = mock_model(New, :save => nil)
#      New.stub!(:finb_by_id).and_return @new
#    end
#
#    context 'when the news is successfully deleted' do
#      before :each do
#        @new.stub!(:destroy).and_return true
#      end
#
#      it 'should load the required news' do
#        New.should_receive(:find_by_id).with('1')
#        delete :destroy, :id => 1
#      end
#
#      it 'should delete the news' do
#        @new.should_receive(:destroy)
#        delete :destroy
#      end
#
#      it 'should set a flash[:notice] message' do
#        delete :destroy
#        flash[:notice].should == I18n.t('new.destroy.success').capitalize
#      end
#
#      it 'should redirect to admins news index' do
#        delete :destroy
#        response.should redirect_to admins_news_path
#      end
#    end
#
#    context 'when the news fails to delete' do
#      before :each do
#        @new.stub!(:destroy).and_return false
#      end
#
#      it 'should assign @new' do
#        delete :destroy
#        assigns[:new].should == @new
#      end
#
#      it 'should set a flash[:error] message' do
#        delete :destroy
#        flash[:error].should == I18n.t('new.destroy.failed').capitalize
#      end
#
#      it 'should redirect to admins news index' do
#        delete :destroy
#        response.should redirect_to admins_news_path
#      end
#    end
#  end
#end