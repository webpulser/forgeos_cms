require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe New do

  describe 'one news' do
    before :each do
      @new = New.create!({:title => 'Jeff Dunham', :content => 'Achmed The Dead Terrorist'})
    end

    it "should be titled 'Hell Yeah'" do
      @new.title.should == 'Jeff Dunham'
    end

    it "should find the news with find_by_id" do
      New.find_by_id(@new.id).should == @new
    end

    it "should have an admin" do
      admin = Admin.create!({:firstname => 'Jeff', :lastname => 'Dunham', :password => 'azerty', :password_confirmation => 'azerty', :email => 'admin@webpulser.com', :country_id => '123548998', :civility => 0})
      @new.admin = admin
      @new.admin.should == admin
    end

    it "should have a Wnews" do
      wnews = Wnew.create!({:title => 'News'})
      @new.wnew = wnews
      @new.wnew.should == wnews
    end
  end

  describe 'all news' do
    it 'should list all news' do
      expected_news = []
      3.times do |i|
        expected_news << New.create({:title => 'Patrick Park', :content => 'Life is A Song'})
      end

      @news = New.all
      @news.length.should == 3
      @news.should == expected_news
    end
  end

  describe 'new news' do
    before :each do
      @news = New.new(:title => 'Fredo Viola', :content => 'The Sad Song')
    end

    it 'should be valid' do
      @news.valid?.should == true
      @news.title.should == 'Fredo Viola'
    end

    it 'should save' do
      @news.save
      New.last.should == @news
    end

    it 'must have a title' do
      @news = New.new
      @news.valid?.should_not == true
    end

    it 'must have a content' do
      @news = New.new
      @news.valid?.should_not == true
    end
  end

  describe 'edit/delete news' do
    before :each do
      @news = New.create(:title => 'Agony Way', :content => 'Don\'t worry')
    end

    #update
    it 'should update attributes' do
      @news.update_attributes(:title => 'new_Agony_Way').should == true

      @new_news = New.find_by_id(@news.id)
      @new_news.should_not == nil
      @new_news.title.should == 'new_Agony_Way'
    end

    it 'should not update attributes if title is missing' do
      @news.update_attributes(:title => '').should_not == true

      @new_news = New.find_by_id(@news.id)
      @new_news.should_not == nil
      @new_news.title.should == 'Agony Way'
    end

    #delete
    it 'should destroy the news' do
      @news.destroy
      New.last.should_not == @news
    end
  end
  
end
