class SearchController < ApplicationController
  before_filter :search_page, :only => :index
private
  def search_page
    @items += Page.search(@keywords)
  end
end
