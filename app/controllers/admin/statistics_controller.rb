class Admin::StatisticsController < Admin::BaseController
  before_filter :pages_most_viewed, :only => :index

  # generates the ofc2 graph
  def graph
    get_date
    # visitors
    visitors = @date.collect{|day| Forgeos::Statistics.total_of_visitors(day)}

    # Bar for visitors
    bar = Bar.new
    bar.values  = visitors
    bar.tooltip = "#val# #{I18n.t('visitor', :count => 2)}"
    bar.colour  = '#F2B833'

    # Conf for Y left axis
    # calculates max number of visitors
    max_visitors = visitors.flatten.compact.max.to_i
    max_count_visitors = max_visitors > 0 ? max_visitors : 5

    return render :json => generate_graph([bar], [max_count_visitors], '#F7BD2E')
  end

private
  def pages_most_viewed
    @pages_most_viewed = Forgeos::CMS::Statistics.pages_most_viewed(@date,10)
  end
end
