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
    end
  end
end
