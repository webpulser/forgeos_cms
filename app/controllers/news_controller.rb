class NewsController < ApplicationController

  def rss
    @news = New.find(:all, :limit => 20, :conditions => {:active => true}, :order => "created_at DESC")
    @feed_title = 'Feed title'
    @feed_description = 'Feed description'
    @locale = 'fr-fr'
    response.headers['Content-Type'] = 'application/rss+xml'
    logger.warn render :action => 'rss', :layout => false
  end
  
end