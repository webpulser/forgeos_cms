class ActualitiesController < ApplicationController

  def rss
    @actualities = Actuality.find_all_by_active(true, :limit => 20, :order => 'created_at DESC')
    @feed_title = 'Feed title'
    @feed_description = 'Feed description'
    @locale = 'fr-fr'
    response.headers['Content-Type'] = 'application/rss+xml'
  end

end
