module Forgeos
  module CMS
    class Statistics
      def self.pages_most_viewed_for_month(date, limit)
        Page.all(
          :conditions => ['YEAR(date) = YEAR(?) AND MONTH(date) = MONTH(?)',date,date],
          :order => 'counter DESC',
          :limit => limit,
          :joins => 'INNER JOIN statistic_counters ON (statistic_counters.type = "PageViewedCounter" AND statistic_counters.element_id = pages.id AND statistic_counters.element_type = "Page")'
        )
      end
    end
  end
end
