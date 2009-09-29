class SearchController < ApplicationController
  after_filter :search_page, :only => :index
private
  def search_page
    @items << Page.search(session[:keyword])
  end
end
