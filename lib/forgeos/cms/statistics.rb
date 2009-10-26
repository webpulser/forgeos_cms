module Forgeos
  module CMS
    class Statistics
      def self.pages_most_viewed(date, limit = nil)
        PageViewedCounter.sum(:counter, :conditions => { :date => date },
          :order => 'sum_counter DESC',
          :limit => limit,
          :group => 'element_id'
        )
      end
      def self.total_of_pages(date)
        PageViewedCounter.count(:conditions => { :date => date })
      end
    end
  end
end
