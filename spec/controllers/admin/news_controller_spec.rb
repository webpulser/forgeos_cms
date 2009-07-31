require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Admin::NewsController, "GET index" do
  should_require_login :get, :index

  describe "admin news" do

    before(:each) do
      login_as_admin
      New.stub!(:all).and_return @news
    end

    it "should load all news" do
      New.should_receive(:all)
      get :index
    end

    it "should assign @news" do
      get :index
      assigns[:news].should == @news
    end
  end

end