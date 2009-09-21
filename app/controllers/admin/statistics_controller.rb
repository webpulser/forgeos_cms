class Admin::StatisticsController < Admin::BaseController
  before_filter :pages_most_viewed, :only => [:index]
private
  def pages_most_viewed
    @pages_most_viewed = Forgeos::CMS::Statistics.pages_most_viewed_for_month(Date.current,10)
  end
end
